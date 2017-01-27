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

      def rails_amp_html_header
        amp_fotmat = ".#{RailsAmp.default_format.to_s}"
        header =<<"EOS"
<meta charset="utf-8">
    <link rel="canonical" href="#{request.url.gsub(amp_fotmat, '')}" />
    <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
    <style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>
    <script async src="https://cdn.ampproject.org/v0.js"></script>
EOS
        header.chomp.html_safe
      end

      def amp?
        RailsAmp.renderable?(controller)
      end

      ::ActionView::Base.send :include, self
    end
  end
end
