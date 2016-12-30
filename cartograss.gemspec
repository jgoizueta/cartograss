# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cartograss/version'

Gem::Specification.new do |spec|
  spec.name          = "cartograss"
  spec.version       = CartoGrass::VERSION
  spec.authors       = ["Javier Goizueta"]
  spec.email         = ["jgoizueta@gmail.com"]

  spec.summary       = %q{Use CARTO datasets in GRASS GIS}
  spec.description   = %q{GRASS functions to import/export CARTO datasets}
  spec.homepage      = "https://github.com/jgoizueta/cartograss"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency 'grassgis', '~> 0.5'
end
