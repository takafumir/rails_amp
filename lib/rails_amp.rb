module RailsAmp
  # Your code goes here...
end

if defined?(Rails::Railtie)
  require 'rails_amp/railtie'
else
  raise "rails_amp is not compatible with Rails 2.* or older"
end
