$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_amp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_amp"
  s.version     = RailsAmp::VERSION
  s.authors     = ["Takafumi Yamano"]
  s.email       = ["takafumiyamano@gmail.com"]
  s.homepage    = "http://example.com"
  s.summary     = "Summary of RailsAmp."
  s.description = "Description of RailsAmp."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"
  s.add_dependency "fastimage"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
