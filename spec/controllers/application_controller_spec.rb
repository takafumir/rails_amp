require 'rails_helper'

describe ApplicationController do
  # just for test
  describe 'hello world' do
    specify { expect('hello world').to eq 'hello world' }
  end
end

# Specs for view helpers: rails_amp_amphtml_link_tag, rails_amp_canonical_url, amp_renderable?.
# These helpers use controller or request object.
describe UsersController do
  context '#index GET' do
    # Users#index is available for amp.
    it 'returns correct amphtml link tag' do
      get 'index'
      expect(rails_amp_amphtml_link_tag).to eq(
        %Q(<link rel="amphtml" href="#{request.base_url}/users.#{RailsAmp.default_format.to_s}" />)
      )
    end

    it 'returns correct amphtml link tag with params' do
      get 'index', sort: 'name'
      expect(rails_amp_amphtml_link_tag).to eq(
        %Q(<link rel="amphtml" href="#{request.base_url}/users.#{RailsAmp.default_format.to_s}?sort=name" />)
      )
    end

    it 'returns correct canonical url' do
      get 'index', format: RailsAmp.default_format.to_s
      expect(request.url).to eq("#{request.base_url}/users.#{RailsAmp.default_format.to_s}")
      expect(rails_amp_canonical_url).to eq("#{request.base_url}/users")
    end

    it 'returns correct canonical url with params' do
      get 'index', format: RailsAmp.default_format.to_s, sort: 'name'
      expect(request.url).to eq("#{request.base_url}/users.#{RailsAmp.default_format.to_s}?sort=name")
      expect(rails_amp_canonical_url).to eq("#{request.base_url}/users?sort=name")
    end

    context 'with html format' do
      it 'is not renderable by amp' do
        get 'index'
        expect(amp_renderable?).to eq false
      end
    end

    context 'with amp format' do
      it 'is renderable by amp' do
        get 'index', format: RailsAmp.default_format.to_s
        expect(amp_renderable?).to eq true
      end
    end
  end

  context '#show GET' do
    let(:user) { User.create(name: 'Taro', email: 'taro@example.com') }

    context 'with html format' do
      it 'is not renderable by amp' do
        get 'show', id: user.id
        expect(amp_renderable?).to eq false
      end
    end

    context 'with amp format' do
      it 'is renderable by amp' do
        get 'show', id: user.id, format: RailsAmp.default_format.to_s
        expect(amp_renderable?).to eq true
      end
    end
  end
end

describe HomeController do
  context '#help GET' do
    # Home#help is not available for amp.
    it 'returns correct amphtml link tag' do
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
        end.to raise_error(ActionController::UnknownFormat)
      end
    end
  end
end
