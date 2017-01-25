module RailsAmp
  class Config
    # Return the current format, default is ''.
    def format
      @format ||= ''
    end

    # Set the current format pseudo-globally, i.e. in the Thread.current hash.
    def format=(format)
      @format = format.to_s
    end

    # Return the default amp format, default is 'amp'
    def default_format
      @@default_format ||= :amp
    end

    # Set the default amp format.
    def default_format=(default_format)
      @@default_format = default_format.to_sym
    end

    # Return the amp enabled controller actions.
    def enables
      @@enables ||= load_enables
    end

    # Set the amp enabled controller actions.
    def enables=(enables)
      @@enables = enables
    end

    # Return the current analytics flag, default is false.
    def analytics
      @@analytics ||= false
    end

    # Set the current analytics flag, set true when you enable google analytics.
    def analytics=(analytics)
      @@analytics = analytics
    end

    # Return the current adsense flag, default is false.
    def adsense
      @@adsense ||= false
    end

    # Set the current adsense flag, set true when you enable google adsense.
    def adsense=(adsense)
      @@adsense = adsense
    end

    private

      def load_enables
        yaml = YAML.load_file("#{Rails.root}/config/rails_amp.yml")
        return {} if yaml.blank?

        if yaml.is_a?(Hash) && yaml.has_key?('application')
          return yaml
        end

        if yaml.is_a?(Hash)
          return yaml.map{ |k, v| [k, v.to_s.split(/\s+/)] }.to_h
        end

        {}
      end
  end
end
