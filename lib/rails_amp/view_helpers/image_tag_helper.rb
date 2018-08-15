require 'fastimage'

module RailsAmp
  module ViewHelpers
    module ImageTagHelper
      # ref: https://www.ampproject.org/docs/reference/components/amp-img
      AMP_IMG_PERMITTED_ATTRIBUTES = %w[
        src srcset alt attribution height width
        fallback heights layout media noloading on placeholder sizes
        class
      ].freeze

      # ref: https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/asset_tag_helper.rb#L228
      def amp_image_tag(source, options={})
        options = options.symbolize_keys
        check_for_image_tag_errors(options) if defined?(check_for_image_tag_errors)

        src = options[:src] = path_to_image(source, skip_pipeline: options.delete(:skip_pipeline))

        unless src.start_with?("cid:") || src.start_with?("data:") || src.blank?
          options[:alt] = options.fetch(:alt) { File.basename(src, '.*') }
        end

        options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]

        if options[:width].blank? || options[:height].blank?
          options[:width], options[:height] = compute_image_size(source)
        end

        options[:layout] ||= 'fixed'
        options.select! { |key, _| key.to_s.in?(AMP_IMG_PERMITTED_ATTRIBUTES) }
        tag('amp-img', options) + '</amp-img>'.html_safe
      end

      # override image_tag helper in ActionView::Helpers::AssetTagHelper
      def image_tag(source, options={})
        if controller && RailsAmp.amp_renderable?(controller.controller_path, controller.action_name)
          amp_image_tag(source, options)
        else
          super
        end
      end

      private

        def compute_image_size(source)
          source_for_fastimage = source
          unless source =~ ::ActionView::Helpers::AssetUrlHelper::URI_REGEXP
            # find_asset is a Sprockets method
            asset_env = Rails.application.assets || ::Sprockets::Railtie.build_environment(Rails.application)
            source_for_fastimage = asset_env.find_asset(source).try(:pathname).to_s.presence ||
                                                                  File.join(Rails.public_path, source)
          end
          FastImage.size(source_for_fastimage) || [300, 300]
        end

      ::ActionView::Base.send :prepend, self
    end
  end
end
