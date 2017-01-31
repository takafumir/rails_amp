require 'rails_helper'

describe RailsAmp do
  it 'returns config directory for test' do
    expect(config_dir).to match( %r(/support/config\z) )
  end
end
