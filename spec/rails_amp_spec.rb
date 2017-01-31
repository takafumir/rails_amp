require 'rails_helper'

describe RailsAmp do
  it 'returns config directory for test' do
    expect(config_dir).to match( %r(/support/config\z) )
  end

  describe Config do
    it 'returns correct config default values' do
      expect(RailsAmp.format).to eq ''
      expect(RailsAmp.config_file).to eq "#{Rails.root}/config/rails_amp.yml"
      expect(RailsAmp.default_format).to eq :amp
      expect(RailsAmp.targets).to eq({ 'users' => ['index', 'show'] })
      expect(RailsAmp.analytics).to eq ''
    end

    specify 'RailsAmp.var equals to RailsAmp.config.var' do
      expect(RailsAmp.format).to eq RailsAmp.config.format
      expect(RailsAmp.config_file).to eq RailsAmp.config.config_file
      expect(RailsAmp.default_format).to eq RailsAmp.config.default_format
      expect(RailsAmp.targets).to eq RailsAmp.config.targets
      expect(RailsAmp.analytics).to eq RailsAmp.config.analytics
    end
  end

  describe 'when changing amp default format' do
    before do
      RailsAmp.config_file = "#{config_dir}/amp_format.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.format).to eq ''
      expect(RailsAmp.config_file).to eq "#{config_dir}/amp_format.yml"
      expect(RailsAmp.default_format).to eq :mobile
      expect(RailsAmp.targets).to eq({})
      expect(RailsAmp.analytics).to eq ''
    end
  end
end
