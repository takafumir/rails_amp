$:.push File.expand_path('../lib', __FILE__)
require 'rails_amp/version'

Gem::Specification.new do |s|
  s.name        = 'rails_amp'
  s.version     = RailsAmp::VERSION
  s.authors     = ['Takafumi Yamano']
  s.email       = ['takafumiyamano@gmail.com']
  s.homepage    = 'https://github.com/takafumir/rails_amp'
  s.summary     = 'AMP(Accelerated Mobile Pages) plugin for Ruby on Rails.'
  s.description = 'RailsAmp is a Ruby on Rails plugin that makes it easy to build views for AMP(Accelerated Mobile Pages).'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files`.split("\n").grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 4.0.0'
  s.add_dependency 'fastimage'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
