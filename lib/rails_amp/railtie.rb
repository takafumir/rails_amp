require 'rails_amp/overrider'

module RailsAmp
  class Railtie < Rails::Railtie
    initializer 'rails_amp' do |app|
      ActiveSupport.on_load :action_controller do
        include RailsAmp::Overrider
      end
      require 'rails_amp/view_helpers/image_tag_helper'
    end
  end
end
