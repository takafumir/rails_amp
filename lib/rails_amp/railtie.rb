module RailsAmp
  class Railtie < Rails::Railtie
    initializer 'rails_amp' do |app|
      ActiveSupport.on_load :action_controller do
        include RailsAmp::SetFormat
      end
    end
  end

  module SetFormat
    extend ActiveSupport::Concern

    included do
      before_action do
        RailsAmp.format = request[:format]
      end
    end
  end
end
