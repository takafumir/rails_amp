require 'yaml'

module RailsAmp
  class Config
    # Return the current format, default is ''. The only configuration value that is not global.
    def format
      @format ||= ''
    end

    # Set the current format pseudo-globally, i.e. in the Thread.current hash.
    def format=(format)
      @format = format.to_s
    end

    # Return the config file path, default is "#{Rails.root}/config/rails_amp.yml".
    def config_file
      @@config_file ||= "#{Rails.root}/config/rails_amp.yml"
    end

    # Set the config file path.
    def config_file=(config_file)
      @@config_file = config_file
    end

    # Return the yaml loaded config, default is YAML.load_file(config_file).
    def load_config
      @@load_config ||= config_load_config
    end

    # Set the config by loading yaml.
    def load_config=(load_config)
      @@load_config = load_config
    end

    # Return the default amp format, default is :amp
    def default_format
      @@default_format ||= config_default_format
    end

    # Set the default amp format.
    def default_format=(default_format)
      @@default_format = default_format.to_sym
    end

    # Return the layout
    def layout
      @@layout
    end

    # Set the layout.
    def layout=(layout)
      @@layout = layout
    end

    # Return the amp enabled controller actions.
    def targets
      @@targets ||= config_targets
    end

    # Set the amp enabled controller actions.
    def targets=(targets)
      @@targets = targets
    end

    # Return the analytics account, default is ''.
    def analytics
      @@analytics ||= config_analytics
    end

    # Set the analytics account.
    def analytics=(analytics)
      @@analytics = analytics
    end

    # Return the lookup_context formats for amp, default is [:html].
    def lookup_formats
      @@lookup_formats ||= config_lookup_formats
    end

    # Set the lookup_context formats for amp.
    def lookup_formats=(lookup_formats)
      @@lookup_formats = lookup_formats
    end

    private

      def config_load_config
        YAML.load_file(config_file)
      end

      def config_default_format
        load_config['default_format'].try(:to_sym) || :amp
      end

      def config_targets
        targets = load_config['targets']
        return {} if targets.blank?

        if targets.is_a?(Hash) && targets.has_key?('application')
          return targets
        end

        if targets.is_a?(Hash)
          return targets.map{ |k, v| [k, v.to_s.split(/\s+/)] }.to_h
        end

        {}
      end

      def config_analytics
        load_config['analytics'] || ''
      end

      def config_layout
        load_config['layout'] || 'rails_amp_application'
      end      

      def config_lookup_formats
        load_config['lookup_formats'].to_s.split(/\s+/).map(&:to_sym).presence || [:html]
      end
  end
end
