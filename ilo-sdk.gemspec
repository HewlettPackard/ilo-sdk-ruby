# coding: utf-8
# http://guides.rubygems.org/specification-reference

require_relative './lib/ilo-sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'ilo-sdk'
  spec.version       = OneviewSDK::VERSION
  spec.authors       = ['Anirudh Gupta', 'Bik Bajwa', 'Jared Smartt', 'Vivek Bhatia']
  spec.email         = ['anirudhg@hpe.com', 'bik.bajwa@hpe.com', 'jared.smartt@hpe.com', 'vivek.bhatia@hpe.com']
  spec.summary       = 'Gem to interact with iLO API'
  spec.description   = 'Gem to interact with iLO API'
  spec.license       = 'Apache-2.0'
  spec.homepage      = 'https://github.com/HewlettPackard/ilo-sdk-ruby'

  all_files = `git ls-files -z`.split("\x0")
  spec.files         = all_files.reject { |f| f.match(%r{^(examples\/)|(spec\/)}) }
  spec.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'pry'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop', '= 0.36.0'

end
