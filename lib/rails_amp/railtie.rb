require 'rails_amp/overrider'

module RailsAmp
  class Railtie < Rails::Railtie
    initializer 'rails_amp' do |app|
      ActiveSupport.on_load :action_controller do
        include RailsAmp::Overrider
      end

      ActiveSupport.on_load :action_view do
        require 'rails_amp/action_view'
      end
    end
  end
end
