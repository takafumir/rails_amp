module RailsAmp
  module Overrider
    extend ActiveSupport::Concern

    included do
      before_action do
        RailsAmp.format = request[:format]
        if RailsAmp.amp_renderable?(controller_path, action_name)  # default_format is :amp
          override_actions_with_rails_amp
        end
      end
    end

    private

      def override_actions_with_rails_amp
        klass = self.class  # klass is controller class
        return if klass.ancestors.include?(RailsAmp::ActionOverrider)
        actions = RailsAmp.target_actions(klass)

        klass.class_eval do
          # override amp target actions
          RailsAmp::ActionOverrider.module_eval do
            actions.to_a.each do |action|
              define_method action.to_sym do
                super()
                unless performed?
                  respond_to do |format|
                    format.send(RailsAmp.default_format.to_sym) do
                      # search amp format(default is .amp) .html templates
                      lookup_context.formats = [RailsAmp.default_format] + RailsAmp.lookup_formats
                      render layout: 'rails_amp_application.amp'
                    end
                  end
                end
              end
            end
          end
          prepend RailsAmp::ActionOverrider
        end
      end
  end

  module ActionOverrider
  end
end
