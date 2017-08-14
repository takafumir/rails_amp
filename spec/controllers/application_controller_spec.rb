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
          %r{(<img border="0" src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" />)|(<img alt="Rails" border="0" height="20" src="/(images|assets)/rails-?\w*?.png" width="30" />)}
        )
        expect(image_tag('rails.png')).to match(
          %r{(<img src="/(images|assets)/rails-?\w*?.png" alt="Rails" />)|(<img alt="Rails" src="/(images|assets)/rails-?\w*?.png" />)}
        )
        # According to dummy app default view `home/_amp_info`
        expect(response.body).to match(
          %r{(<img border="0" src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" />)|(<img alt="Rails" border="0" height="20" src="/(images|assets)/rails-?\w*?.png" width="30" />)}
        )
      end
    end
    context '#trailing_slash GET' do
      it 'has correct amphtml(with trailing slash) link tag' do
        get 'trailing_slash'
        expect(rails_amp_amphtml_link_tag(trailing_slash: true)).to eq(
          %Q(<link rel="amphtml" href="#{request.base_url}/users/trailing_slash.#{RailsAmp.default_format.to_s}/" />)
        )
        expect(response.body).to include(
          %Q(<link rel="amphtml" href="#{request.base_url}/users/trailing_slash.#{RailsAmp.default_format.to_s}/" />)
        )
      end

      it 'has correct amphtml(with trailing slash) link tag with params' do
        get 'trailing_slash', params: {sort: 'name'}
        expect(rails_amp_amphtml_link_tag(trailing_slash: true)).to eq(
          %Q(<link rel="amphtml" href="#{request.base_url}/users/trailing_slash.#{RailsAmp.default_format.to_s}/?sort=name" />)
        )
        expect(response.body).to include(
          %Q(<link rel="amphtml" href="#{request.base_url}/users/trailing_slash.#{RailsAmp.default_format.to_s}/?sort=name" />)
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
          %r{(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" layout="fixed" /></amp-img>)|(<amp-img alt="Rails" height="20" layout="fixed" src="/(images|assets)/rails-?\w*?.png" width="30" /></amp-img>)}
        )
        expect(image_tag('rails.png')).to match(
          %r{(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="50" height="64" layout="fixed" /></amp-img>)|(<amp-img alt="Rails" height="64" layout="fixed" src="/(images|assets)/rails-?\w*?.png" width="50" /></amp-img>)}
        )
        # According to dummy app default view `home/_amp_info`
        expect(response.body).to match(
          %r{(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" layout="fixed" /></amp-img>)|(<amp-img alt="Rails" height="20" layout="fixed" src="/(images|assets)/rails-?\w*?.png" width="30" /></amp-img>)}
        )
      end
    end

    context '#redirect GET' do
      it 'allows redirect_to or render' do
        if Gem.loaded_specs["rails"].version.to_s >= "5"
          get 'index', params: { redirect_test: true }, format: RailsAmp.default_format.to_s
        else
          get 'index', redirect_test: true, format: RailsAmp.default_format.to_s
        end

        expect(response).to redirect_to(root_path)
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

describe Admin::SessionsController do
  # Admin::SessionsController#index is not available for amp.
  it 'does not return amphtml link tag' do
    get 'index'
    expect(rails_amp_amphtml_link_tag).to eq ''
  end

  context 'with html format' do
    it 'is not renderable by amp' do
      get 'index'
      expect(amp_renderable?).to eq false
    end
  end

  context 'with amp format' do
    it 'is not renderable by amp' do
      expect do
        get 'index', format: RailsAmp.default_format.to_s
      end.to raise_error(StandardError) # ActionView::MissingTemplate or ActionController::UnknownFormat
    end
  end
end

describe Admin::UsersController do
  render_views

  context '#index GET' do
    # Admin::Users#index is available for amp.
    it 'has correct amphtml link tag' do
      get 'index'
      expect(rails_amp_amphtml_link_tag).to eq(
        %(<link rel="amphtml" href="#{request.base_url}/admin/users.#{RailsAmp.default_format}" />)
      )
      expect(response.body).to include(
        %(<link rel="amphtml" href="#{request.base_url}/admin/users.#{RailsAmp.default_format}" />)
      )
    end

    it 'has correct amphtml link tag with params' do
      get 'index', params: { sort: 'name' }
      expect(rails_amp_amphtml_link_tag).to eq(
        %(<link rel="amphtml" href="#{request.base_url}/admin/users.#{RailsAmp.default_format}?sort=name" />)
      )
      expect(response.body).to include(
        %(<link rel="amphtml" href="#{request.base_url}/admin/users.#{RailsAmp.default_format}?sort=name" />)
      )
    end

    it 'has correct canonical url' do
      get 'index', format: RailsAmp.default_format.to_s
      expect(request.url).to eq("#{request.base_url}/admin/users.#{RailsAmp.default_format}")
      expect(rails_amp_canonical_url).to eq("#{request.base_url}/admin/users")
      expect(response.body).to include(
        %(<link rel="canonical" href="#{request.base_url}/admin/users" />)
      )
    end

    it 'has correct canonical url with params' do
      get 'index', format: RailsAmp.default_format.to_s, params: { sort: 'name' }
      expect(request.url).to eq("#{request.base_url}/admin/users.#{RailsAmp.default_format}?sort=name")
      expect(rails_amp_canonical_url).to eq("#{request.base_url}/admin/users?sort=name")
      expect(response.body).to include(
        %(<link rel="canonical" href="#{request.base_url}/admin/users?sort=name" />)
      )
    end

    context 'with html format' do
      it 'is not renderable by amp' do
        get 'index'
        expect(amp_renderable?).to eq false
      end

      it 'has normal image tag' do
        get 'index'
        expect(image_tag('rails.png', size: '30x20', border: '0')).to match(
          %r{(<img border="0" src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" />)|(<img alt="Rails" border="0" height="20" src="/(images|assets)/rails-?\w*?.png" width="30" />)}
        )
        expect(image_tag('rails.png')).to match(
          %r{(<img src="/(images|assets)/rails-?\w*?.png" alt="Rails" />)|(<img alt="Rails" src="/(images|assets)/rails-?\w*?.png" />)}
        )
        # According to dummy app default view `home/_amp_info`
        expect(response.body).to match(
          %r{(<img border="0" src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" />)|(<img alt="Rails" border="0" height="20" src="/(images|assets)/rails-?\w*?.png" width="30" />)}
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
        expect(image_tag('rails.png', size: '30x20', border: '0')).to match(
          %r{(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" layout="fixed" /></amp-img>)|(<amp-img alt="Rails" height="20" layout="fixed" src="/(images|assets)/rails-?\w*?.png" width="30" /></amp-img>)}
        )
        expect(image_tag('rails.png')).to match(
          %r{(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="50" height="64" layout="fixed" /></amp-img>)|(<amp-img alt="Rails" height="64" layout="fixed" src="/(images|assets)/rails-?\w*?.png" width="50" /></amp-img>)}
        )
        # According to dummy app default view `home/_amp_info`
        expect(response.body).to match(
          %r{(<amp-img src="/(images|assets)/rails-?\w*?.png" alt="Rails" width="30" height="20" layout="fixed" /></amp-img>)|(<amp-img alt="Rails" height="20" layout="fixed" src="/(images|assets)/rails-?\w*?.png" width="30" /></amp-img>)}
        )
      end
    end
  end
end
