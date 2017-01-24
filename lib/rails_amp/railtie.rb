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
        if request[:format] == RailsAmp.amp_format.to_s  # default amp_format is :amp
          override_with_amp
        end
      end
    end

    private

      def override_with_amp
        return if defined?(@@override_with_amp) && @@override_with_amp
        klass = self.class
        actions = amp_actions(klass)
        klass.class_eval do
          prepend(Module.new {
            actions.to_a.each do |action|
              define_method action.to_sym do
                super()
                respond_to do |format|
                  format.amp do
                    # search .amp .html templates
                    lookup_context.formats = [:amp, :html]
                    render layout: false
                  end
                end
              end
            end
          })
          @@override_with_amp = true
        end
      end

      def amp_actions(klass)
        return []                        if RailsAmp.disable_all?
        return klass.action_methods.to_a if RailsAmp.enable_all?
        key = klass.name.underscore.sub(/_controller\z/, '')
        return klass.action_methods.to_a if amp_controller_all?(key)
        return RailsAmp.enables[key]     if amp_controller_actions?(key)
        []
      end

      def amp_controller_all?(key)
        RailsAmp.enables.has_key?(key) && RailsAmp.enables[key].blank?
      end

      def amp_controller_actions?(key)
        RailsAmp.enables.has_key?(key) && RailsAmp.enables[key].present?
      end
  end
end
