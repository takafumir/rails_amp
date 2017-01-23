module RailsAmp
  class Config
    # Get the amp enabled controller actions.
    def enables
      @enables ||= load_enables
    end

    # Return the amp enabled controller actions.
    def enables=(enables)
      @enables = enables
    end

    # Get the current format, default is nil.
    def format
      @format ||= nil
    end

    # Return the current format pseudo-globally, i.e. in the Thread.current hash.
    def format=(format)
      @format = format.to_s
    end

    # Return the default amp format, default is 'amp'
    def amp_format
      @@amp_format ||= :amp
    end

    # Return the default amp format.
    def amp_format=(format)
      @@amp_format = format.to_sym
    end

    # Get the current analytics flag, default is false.
    def analytics
      @analytics ||= false
    end

    # Return analytics true when you enable google analytics.
    def analytics=(analytics)
      @analytics = analytics
    end

    # Get the current adsense flag, default is false.
    def adsense
      @adsense ||= false
    end

    # Return adsense true when you enable google adsense.
    def adsense=(adsense)
      @adsense = adsense
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
