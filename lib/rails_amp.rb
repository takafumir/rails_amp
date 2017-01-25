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
    %w( format default_format targets analytics ).each do |method|
      module_eval <<-DELEGATORS, __FILE__, __LINE__ + 1
        def #{method}
          config.#{method}
        end

        def #{method}=(value)
          config.#{method} = (value)
        end
      DELEGATORS
    end

    def disable_all?
      RailsAmp.targets.blank?
    end

    def enable_all?
      RailsAmp.targets['application'] == 'all'
    end

    def controller_all?(key)
      RailsAmp.targets.has_key?(key) && RailsAmp.targets[key].blank?
    end

    def controller_actions?(key)
      RailsAmp.targets.has_key?(key) && RailsAmp.targets[key].present?
    end

    def target_actions(klass)
      return []                        if RailsAmp.disable_all?
      return klass.action_methods.to_a if RailsAmp.enable_all?
      key = klass.name.underscore.sub(/_controller\z/, '')
      return klass.action_methods.to_a if RailsAmp.controller_all?(key)
      return RailsAmp.targets[key]     if RailsAmp.controller_actions?(key)
      []
    end
  })
end
