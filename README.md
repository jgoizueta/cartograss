# CartoGrass

[![Gem Version](https://badge.fury.io/rb/cartograss.svg)](http://badge.fury.io/rb/cartograss)

Import and Export [CARTO](http://carto.com) datasets as [GRASS GIS](https://grass.osgeo.org/) maps,
using the [GrassGis](https://github.com/jgoizueta/grassgis) Ruby Gem.

Works with GRASS 7.x and only with vector geometry.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cartograss'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cartograss

## Usage

You'll need a [CARTO engine](https://carto.com/engine/) account 
(that is, one with an authorized API KEY).

This example fetches some data from your CARTO account, then processes it in GRASS and
sends the results back to CARTO so they can be visualized in web maps.

```ruby
require 'cartograss'

grass_config = {
  # ...
}

GrassGis.session grass_config do
  extend CartoGrass

  # Bring-in a dataset from CARTO.
  # It is automatically reprojected for the current locations
  carto_import(
    user: 'carto_username',
    api_key: 'secret_api_key',
    dataset: 'mydataset'
  )

  # ... process mydataset with GRASS tools ...

  # Now save the changed dataset back to CARTO.
  carto_export(
    user: 'carto_username',
    api_key: 'secret_api_key',
    input: 'mydataset',
    dataset: 'mydataset'
  )
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cartograss. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
