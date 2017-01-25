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
        if request[:format] == RailsAmp.default_format.to_s  # default_format is :amp
          override_actions_with_rails_amp
        end
      end
    end

    private

      def override_actions_with_rails_amp
        klass = self.class
        actions = RailsAmp.target_actions(klass)
        klass.class_eval do
          return if defined?(@override_actions_with_rails_amp) && @override_actions_with_rails_amp
          prepend(Module.new {
            actions.to_a.each do |action|
              define_method action.to_sym do
                super()
                respond_to do |format|
                  format.send(RailsAmp.default_format.to_sym) do
                    # search amp format(default is .amp) .html templates
                    lookup_context.formats = [RailsAmp.default_format, :html]
                    render layout: 'rails_amp_application.amp'
                  end
                end
              end
            end
          })
          @override_actions_with_rails_amp = true
        end
      end
  end
end
