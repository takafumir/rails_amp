module RailsAmp
  class Railtie < Rails::Railtie
    initializer 'rails_amp' do |app|
      ActiveSupport.on_load :action_controller do
        include RailsAmp::Initializer
      end
    end
  end

  module Initializer
    extend ActiveSupport::Concern

    included do
      before_action do
        RailsAmp.format = request[:format]
        if request[:format] == 'amp'
          override_with_amp
        end
      end
    end

    def override_with_amp
      klass = self.class
      key = klass.name.underscore.sub(/_controller\z/, '')
      klass.class_eval do
        prepend(Module.new {
          RailsAmp.enables[key].to_a.each do |action|
            define_method action.to_sym do
              super()
              respond_to do |format|
                format.amp do
                  # search .amp .html templates
                  lookup_context.formats = [:amp, :html]
                end
              end
            end
          end
        })
      end
    end
  end
end
