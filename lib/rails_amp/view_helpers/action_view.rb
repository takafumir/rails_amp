module RailsAmp
  module ViewHelpers
    module ActionView

      # To add header code in default layout like application.html.erb.
      def link_rel_amphtml
        if RailsAmp.target?(controller)
          amp_uri = URI.parse(request.url)
          amp_uri.path = "#{amp_uri.path}.#{RailsAmp.default_format}"
          amp_uri.query = h(amp_uri.query) if amp_uri.query.present?
          return %Q(<link rel="amphtml" href="#{amp_uri.to_s}" />).html_safe
        end
        ''
      end

      ::ActionView::Base.send :include, self
    end
  end
end
