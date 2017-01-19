module RailsAmp
  class Railtie < Rails::Railtie
    initializer "rails_amp" do |app|
      ActiveSupport.on_load :action_controller do
        include RailsAmp::Format
      end
    end
  end

  module Format
    extend ActiveSupport::Concern

    included do
      before_action :set_rails_amp_format
    end    

    def set_rails_amp_format
      Thread.current[:rails_amp_format] = request[:format]
    end
  end
end
