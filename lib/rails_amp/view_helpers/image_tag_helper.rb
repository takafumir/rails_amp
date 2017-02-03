require 'fastimage'

module RailsAmp
  module ViewHelpers
    module ImageTagHelper
      # ref: https://www.ampproject.org/docs/reference/components/amp-img
      AMP_IMG_PERMITTED_ATTRIBUTES = %w(
        src srcset alt attribution height width fallback heights layout media noloading on placeholder sizes
      )

      # ref: https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/asset_tag_helper.rb#L228
      def amp_image_tag(source, options={})
        options = options.symbolize_keys
        check_for_image_tag_errors(options) if defined?(check_for_image_tag_errors)

        src = options[:src] = path_to_image(source, skip_pipeline: options.delete(:skip_pipeline))

        unless src.start_with?("cid:") || src.start_with?("data:") || src.blank?
          options[:alt] = options.fetch(:alt){ image_alt(src) }
        end

        if defined?(extract_dimensions)
          options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
        else
          # for rails 4.0.x
          if size = options.delete(:size)
            options[:width], options[:height] = size.split("x") if size =~ %r{\A\d+x\d+\z}
            options[:width] = options[:height] = size if size =~ %r{\A\d+\z}
          end
        end

        if options[:width].blank? || options[:height].blank?
          options[:width], options[:height] = FastImage.size(request.base_url + src)
        end

        options[:layout] ||= 'fixed'

        options.select! { |key, _| key.to_s.in?(AMP_IMG_PERMITTED_ATTRIBUTES) }
        tag('amp-img', options) + '</amp-img>'.html_safe
      end

      # override image_tag helper in ActionView::Helpers::AssetTagHelper
      def image_tag(source, options={})
        if controller && RailsAmp.amp_renderable?(controller.controller_name, controller.action_name)
          amp_image_tag(source, options)
        else
          super
        end
      end

      ::ActionView::Base.send :prepend, self
    end
  end
end
