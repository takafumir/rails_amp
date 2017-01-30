module RailsAmp
  module Overrider
    extend ActiveSupport::Concern

    included do
      before_action do
        RailsAmp.format = request[:format]
        if RailsAmp.amp_format?  # default_format is :amp
          override_actions_with_rails_amp
        end
      end
    end

    private

      def override_actions_with_rails_amp
        klass = self.class
        return if klass.action_methods.include?('dummy_action_to_check_rails_amp_override')
        actions = RailsAmp.target_actions(klass)

        klass.class_eval do
          # override amp target actions
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
          def dummy_action_to_check_rails_amp_override; end
        end
      end
  end
end
