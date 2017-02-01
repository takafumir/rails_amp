require 'rails_helper'

describe RailsAmp::ViewHelpers::ActionView do
  specify 'amphtml helper returns correct link tag' do
    expect(rails_amp_amphtml_link_tag).to eq '<link rel="amphtml" href="hoge" />'
  end
end
