require 'rails_helper'

# Specs for view helpers:
# rails_amp_html_header, rails_amp_google_analytics_head, rails_amp_google_analytics_page_tracking
# These helpers don't use controller or request object.
describe RailsAmp::ViewHelpers::ActionView do
  context '#rails_amp_html_header' do
    it 'returns correct amp header' do
      expect(rails_amp_html_header).to include('style amp-boilerplate')
      expect(rails_amp_html_header).to include('script async src="https://cdn.ampproject.org')
    end
  end

  context '#rails_amp_google_analytics disabled' do
    it 'returns analytics off' do
      expect(RailsAmp.analytics).to eq ''
      expect(rails_amp_google_analytics_head).to eq ''
      expect(rails_amp_google_analytics_page_tracking).to eq ''
    end
  end

  context '#rails_amp_google_analytics enabled' do
    before(:each) do
      RailsAmp.analytics = 'UA-12345-6'
    end

    after(:each) do
      RailsAmp.config_file = "#{Rails.root}/config/rails_amp.yml"
      RailsAmp.reload_config!
    end

    it 'returns analytics on' do
      expect(RailsAmp.analytics).to eq 'UA-12345-6'
      expect(rails_amp_google_analytics_head).to include('script async custom-element="amp-analytics"')
      expect(rails_amp_google_analytics_page_tracking).to include('"account": "UA-12345-6"')
    end
  end

end
