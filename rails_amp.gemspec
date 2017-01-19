$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_amp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_amp"
  s.version     = RailsAmp::VERSION
  s.authors     = ["Takafumi Yamano"]
  s.email       = ["takafumiyamano@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RailsAmp."
  s.description = "TODO: Description of RailsAmp."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
end
