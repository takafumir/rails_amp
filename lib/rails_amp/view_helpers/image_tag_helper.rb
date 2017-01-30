require 'fastimage'

module RailsAmp
  module ViewHelpers
    module ImageTagHelper
      # ref: https://www.ampproject.org/docs/reference/components/amp-img
      AMP_IMG_PERMITTED_ATTRIBUTES = %w(
        src srcset alt attribution height width fallback heights layout media noloading on placeholder sizes
      )

      def amp_image_tag(source, options={})
        options = options.symbolize_keys
        check_for_image_tag_errors(options)

        src = options[:src] = path_to_image(source, skip_pipeline: options.delete(:skip_pipeline))

        unless src =~ /^(?:cid|data):/ || src.blank?
          options[:alt] = options.fetch(:alt){ image_alt(src) }
        end

        options[:layout] ||= 'fixed'
        options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]

        if options[:width].blank? || options[:height].blank?
          options[:width], options[:height] = FastImage.size(request.base_url + src)
        end

        options.select! { |key, _| key.to_s.in?(AMP_IMG_PERMITTED_ATTRIBUTES) }
        tag('amp-img', options) + '</amp-img>'.html_safe
      end

      # override image_tag helper
      def image_tag(source, options={})
        if RailsAmp.renderable?(controller)
          amp_image_tag(source, options)
        else
          super
        end
      end

      ::ActionView::Helpers::AssetTagHelper.send :prepend, self
    end
  end
end
