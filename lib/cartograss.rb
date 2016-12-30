require "cartograss/version"

module CartoGrass
  def carto_import(user:, dataset:, api_key:)
    with_api_key api_key do
      if epsg4326?
        v.in.ogr(
          '-o',
          input: "#{CARTO_OGR}:#{user} tables=#{dataset}",
          layer: dataset,
          output: dataset
        )
      else
        v.import(
          input: "#{CARTO_OGR}:#{user} tables=#{dataset}",
          layer: dataset,
          output: dataset,
          epsg: 4326
        )
      end
    end
  end

  def carto_export(user:, api_key:, input:, dataset:, overwrite: false)
    if epsg4326?
      carto_export_4326 user: user, api_key: api_key, input: input, dataset: dataset, overwrite: overwrite
    else
      projected = self
      GrassGis.session(configuration.merge(CARTO_TMP_4326)) do
        v.proj(
          '--overwrite',
          location: projected.configuration[:location],
          mapset:   projected.configuration[:mapset],
          input:    input
        )
        extend CartoGrass
        carto_export_4326 user: user, api_key: api_key, input: input, dataset: dataset, overwrite: true
      end

      # GrassGis.session(configuration.merge(CARTO_TMP_4326)) do |carto_tmp|
      #   carto_tmp.v.proj(
      #     '--overwrite',
      #     location: configuration[:location],
      #     mapset:   configuration[:mapset],
      #     input:    input
      #   )
      #   carto_tmp.extend CartoGrass
      #   carto_tmp.send :carto_export_4326, user: user, api_key: api_key, input: input, dataset: dataset, overwrite: overwrite
      # end
    end
  end

  private

  CARTO_OGR = 'CartoDB'
  CARTO_TMP_4326 = {
    location: 'carto_tmp',
    mapset: 'maps_4326',
    create: {
      epsg: 4326,
      limits: [-180.0, 0.0, 180.0, 90.0]
    }
  }

  def epsg4326?
    g.proj '-g'
    proj = shell_to_hash
    proj['epsg'] == '4326' ||
    proj['ellps'] == 'wgs84' && proj['proj'] == 'll' && proj['unit'] == 'degrees'
  end

  def with_api_key(api_key)
    api_key_var = "#{CARTO_OGR.upcase}_API_KEY"
    begin
      ENV[api_key_var] = api_key
      yield
    ensure
      ENV.delete api_key_var
    end
  end

  def carto_export_4326(user:, api_key:, input:, dataset:, overwrite: false)
    with_api_key api_key do
      if overwrite
        v.out.ogr(
          '--overwrite',
          format: CARTO_OGR,
          input: input,
          output: "#{CARTO_OGR}:#{user} tables=#{dataset}",
          output_layer: dataset
        )
      else
        # first create layer to avoid problem reading all layers
        v.out.ogr(
          '-n',
          format: CARTO_OGR,
          input: input,
          output: "#{CARTO_OGR}:#{user}",
          output_layer: dataset
        )
        # now overwrite it:
        v.out.ogr(
          '--overwrite',
          format: CARTO_OGR,
          input: input,
          output: "#{CARTO_OGR}:#{user} tables=#{dataset}",
          output_layer: dataset
        )
      end
    end
  end
end
