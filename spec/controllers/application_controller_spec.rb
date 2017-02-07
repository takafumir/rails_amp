require 'rails_helper'

describe ApplicationController do
  # just for test
  describe 'hello world' do
    specify { expect('hello world').to eq 'hello world' }
  end
end

# Specs for ActionView helpers: rails_amp_amphtml_link_tag, rails_amp_canonical_url, amp_renderable?.
# And specs for ImageTagHelper: amp_image_tag, image_tag
# These helpers use controller or request object.
describe UsersController do
  render_views

  context '#index GET' do
    # Users#index is available for amp.
    it 'has correct amphtml link tag' do
      get 'index'
      expect(rails_amp_amphtml_link_tag).to eq(
        %Q(<link rel="amphtml" href="#{request.base_url}/users.#{RailsAmp.default_format.to_s}" />)
      )
      expect(response.body).to include(
        %Q(<link rel="amphtml" href="#{request.base_url}/users.#{RailsAmp.default_format.to_s}" />)
      )
    end

    it 'has correct amphtml link tag with params' do
      get 'index', params: {sort: 'name'}
      expect(rails_amp_amphtml_link_tag).to eq(
        %Q(<link rel="amphtml" href="#{request.base_url}/users.#{RailsAmp.default_format.to_s}?sort=name" />)
      )
      expect(response.body).to include(
        %Q(<link rel="amphtml" href="#{request.base_url}/users.#{RailsAmp.default_format.to_s}?sort=name" />)
      )
    end

    it 'has correct canonical url' do
      get 'index', format: RailsAmp.default_format.to_s
      expect(request.url).to eq("#{request.base_url}/users.#{RailsAmp.default_format.to_s}")
      expect(rails_amp_canonical_url).to eq("#{request.base_url}/users")
      expect(response.body).to include(
        %Q(<link rel="canonical" href="#{request.base_url}/users" />)
      )
    end

    it 'has correct canonical url with params' do
      get 'index', format: RailsAmp.default_format.to_s, params: {sort: 'name'}
      expect(request.url).to eq("#{request.base_url}/users.#{RailsAmp.default_format.to_s}?sort=name")
      expect(rails_amp_canonical_url).to eq("#{request.base_url}/users?sort=name")
      expect(response.body).to include(
        %Q(<link rel="canonical" href="#{request.base_url}/users?sort=name" />)
      )
    end

    context 'with html format' do
      it 'is not renderable by amp' do
        get 'index'
        expect(amp_renderable?).to eq false
      end

      it 'has normal image tag' do
        get 'index'
        expect(image_tag('rails.png', {size: '30x20', border: '0'})).to match(
          %r(<img border="0" src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" />)
        )
        expect(image_tag('rails.png')).to match(
          %r(<img src="/(images|assets)/rails-?\w*?.png" alt="Rails" />)
        )
        # According to dummy app default view `home/_amp_info`
        expect(response.body).to match(
          %r(<img border="0" src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" />)
        )
      end
    end

    context 'with amp format' do
      it 'is renderable by amp' do
        get 'index', format: RailsAmp.default_format.to_s
        expect(amp_renderable?).to eq true
      end

      it 'has amp-img tag' do
        get 'index', format: RailsAmp.default_format.to_s
        expect(image_tag('rails.png', {size: '30x20', border: '0'})).to match(
          %r(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" layout="fixed" /></amp-img>)
        )
        expect(image_tag('rails.png')).to match(
          %r(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="50" height="64" layout="fixed" /></amp-img>)
        )
        # According to dummy app default view `home/_amp_info`
        expect(response.body).to match(
          %r(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" layout="fixed" /></amp-img>)
        )
      end
    end
  end
end

describe HomeController do
  context '#help GET' do
    # Home#help is not available for amp.
    it 'does not return amphtml link tag' do
      get 'help'
      expect(rails_amp_amphtml_link_tag).to eq ''
    end

    context 'with html format' do
      it 'is not renderable by amp' do
        get 'help'
        expect(amp_renderable?).to eq false
      end
    end

    context 'with amp format' do
      it 'is not renderable by amp' do
        expect do
          get 'help', format: RailsAmp.default_format.to_s
        end.to raise_error(StandardError)  # ActionView::MissingTemplate or ActionController::UnknownFormat
      end
    end
  end
end
