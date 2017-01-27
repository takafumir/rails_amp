module RailsAmp
  module ViewHelpers
    module ImageTagHelper
      def amp_image_tag(source, options={})
        options = options.symbolize_keys
        check_for_image_tag_errors(options)

        src = options[:src] = path_to_image(source, skip_pipeline: options.delete(:skip_pipeline))

        unless src =~ /^(?:cid|data):/ || src.blank?
          options[:alt] = options.fetch(:alt){ image_alt(src) }
        end

        options[:layout] ||= 'fixed'
        options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
        tag('amp-img', options) + '</amp-img>'.html_safe
      end

      ::ActionView::Helpers::AssetTagHelper.module_eval do
        alias_method :image_tag_without_amp, :image_tag
      end

      # override image_tag helper
      def image_tag(source, options={})
        if RailsAmp.renderable?(controller)
          amp_image_tag(source, options)
        else
          image_tag_without_amp(source, options)
        end
      end

      ::ActionView::Helpers::AssetTagHelper.send :prepend, self
    end
  end
end
