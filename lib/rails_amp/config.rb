module RailsAmp
  class Config
    # Get the amp enabled controller actions.
    def enables
      @enables ||= YAML.load_file("#{Rails.root}/config/rails_amp.yml").map{ |k, v| [k, v.split(/\s+/)] }.to_h
    end

    # Set the amp enabled controller actions.
    def enables=(enables)
      @enables = enables
    end

    # Get the current format, default is nil.
    def format
      @format ||= nil
    end

    # Set the current format pseudo-globally, i.e. in the Thread.current hash.
    def format=(format)
      @format = format.to_s
    end

    # Get the current analytics flag, default is false.
    def analytics
      @analytics ||= false
    end

    # Set analytics true when you enable google analytics.
    def analytics=(analytics)
      @analytics = analytics
    end

    # Get the current adsense flag, default is false.
    def adsense
      @adsense ||= false
    end

    # Set adsense true when you enable google adsense.
    def adsense=(adsense)
      @adsense = adsense
    end
  end
end
