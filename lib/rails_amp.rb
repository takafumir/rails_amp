require 'rails_amp/version'

if defined?(Rails::Railtie)
  require 'rails_amp/railtie'
else
  raise 'rails_amp is not compatible with Rails 2.* or older'
end

module RailsAmp
  autoload :Config, 'rails_amp/config'

  extend(Module.new {
    # Get RailsAmp configuration object.
    def config
      Thread.current[:rails_amp_config] ||= RailsAmp::Config.new
    end

    # Set RailsAmp configuration object.
    def config=(value)
      Thread.current[:rails_amp_config] = value
    end

    # Write methods which delegates to the configuration object.
    %w( format amp_format analytics adsense enables ).each do |method|
      module_eval <<-DELEGATORS, __FILE__, __LINE__ + 1
        def #{method}
          config.#{method}
        end

        def #{method}=(value)
          config.#{method} = (value)
        end
      DELEGATORS
    end
  })
end
