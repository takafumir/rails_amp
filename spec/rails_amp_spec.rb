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

  context 'when using default /config/rails_amp.yml' do
    it 'returns correct config values' do
      expect(RailsAmp.targets).to eq({ 'users' => ['index', 'show'] })
      expect(RailsAmp.target_actions(UsersController)).to eq ['index', 'show']
      expect(RailsAmp.target_actions(HomeController)).to eq []
      expect(RailsAmp.target?('users', 'index')).to eq true
      expect(RailsAmp.target?('users', 'show')).to eq true
      expect(RailsAmp.target?('home', 'index')).to eq false
      expect(RailsAmp.target?('home', 'help')).to eq false
      expect(RailsAmp.target?('home', 'about')).to eq false
    end
  end

  context 'when changing amp default format' do
    before do
      RailsAmp.config_file = "#{config_dir}/amp_format.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.config_file).to eq "#{config_dir}/amp_format.yml"
      expect(RailsAmp.default_format).to eq :mobile
    end
  end

  context 'when using amp on some controller actions' do
    before do
      RailsAmp.config_file = "#{config_dir}/controller_actions.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.config_file).to eq "#{config_dir}/controller_actions.yml"
      expect(RailsAmp.targets).to eq({ 'home' => ['about', 'help'], 'users' => ['show'] })
      expect(RailsAmp.disable_all?).to eq false
      expect(RailsAmp.enable_all?).to eq false
      expect(RailsAmp.controller_all?('home')).to eq false
      expect(RailsAmp.controller_all?('users')).to eq false
      expect(RailsAmp.controller_actions?('home')).to eq true
      expect(RailsAmp.controller_actions?('users')).to eq true
      expect(RailsAmp.target_actions(UsersController)).to eq ['show']
      expect(RailsAmp.target_actions(HomeController)).to eq ['about', 'help']
      expect(RailsAmp.target?('users', 'index')).to eq false
      expect(RailsAmp.target?('users', 'show')).to eq true
      expect(RailsAmp.target?('home', 'index')).to eq false
      expect(RailsAmp.target?('home', 'help')).to eq true
      expect(RailsAmp.target?('home', 'about')).to eq true
    end
  end

  context 'when using amp on controller all actions' do
    before do
      RailsAmp.config_file = "#{config_dir}/controller_all.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.config_file).to eq "#{config_dir}/controller_all.yml"
      expect(RailsAmp.targets).to eq({ 'home' => [] })
      expect(RailsAmp.disable_all?).to eq false
      expect(RailsAmp.enable_all?).to eq false
      expect(RailsAmp.controller_all?('home')).to eq true
      expect(RailsAmp.controller_actions?('home')).to eq false
      expect(RailsAmp.target_actions(UsersController)).to eq []
      expect(RailsAmp.target_actions(HomeController)).to eq ['index', 'help', 'about']
      expect(RailsAmp.target?('users', 'index')).to eq false
      expect(RailsAmp.target?('users', 'show')).to eq false
      expect(RailsAmp.target?('home', 'index')).to eq true
      expect(RailsAmp.target?('home', 'help')).to eq true
      expect(RailsAmp.target?('home', 'about')).to eq true
    end
  end

  context 'when not using amp on all controllers actions' do
    before do
      RailsAmp.config_file = "#{config_dir}/disable_all.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.config_file).to eq "#{config_dir}/disable_all.yml"
      expect(RailsAmp.targets).to eq({})
      expect(RailsAmp.disable_all?).to eq true
      expect(RailsAmp.enable_all?).to eq false
      expect(RailsAmp.target_actions(UsersController)).to eq []
      expect(RailsAmp.target_actions(HomeController)).to eq []
      expect(RailsAmp.target?('users', 'index')).to eq false
      expect(RailsAmp.target?('users', 'show')).to eq false
      expect(RailsAmp.target?('home', 'index')).to eq false
      expect(RailsAmp.target?('home', 'help')).to eq false
      expect(RailsAmp.target?('home', 'about')).to eq false
    end
  end

  context 'when using amp on all controllers actions' do
    before do
      RailsAmp.config_file = "#{config_dir}/enable_all.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.config_file).to eq "#{config_dir}/enable_all.yml"
      expect(RailsAmp.targets).to eq({ 'application' => 'all' })
      expect(RailsAmp.disable_all?).to eq false
      expect(RailsAmp.enable_all?).to eq true
      expect(RailsAmp.target_actions(UsersController)).to eq ['index', 'show']
      expect(RailsAmp.target_actions(HomeController)).to eq ['index', 'help', 'about']
      expect(RailsAmp.target?('users', 'index')).to eq true
      expect(RailsAmp.target?('users', 'show')).to eq true
      expect(RailsAmp.target?('home', 'index')).to eq true
      expect(RailsAmp.target?('home', 'help')).to eq true
      expect(RailsAmp.target?('home', 'about')).to eq true
    end
  end

  context 'when using google analytics' do
    before do
      RailsAmp.config_file = "#{config_dir}/enable_analytics.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.config_file).to eq "#{config_dir}/enable_analytics.yml"
      expect(RailsAmp.analytics).to eq 'UA-12345-6'
    end
  end

  context 'when using various configs' do
    before do
      RailsAmp.config_file = "#{config_dir}/various.yml"
      RailsAmp.reload_config!
    end

    it 'returns correct config values' do
      expect(RailsAmp.format).to eq ''
      expect(RailsAmp.config_file).to eq "#{config_dir}/various.yml"
      expect(RailsAmp.default_format).to eq :amphtml
      expect(RailsAmp.targets).to eq({ 'home' => ['index', 'about'], 'users' => ['index'] })
      expect(RailsAmp.analytics).to eq 'UA-12345-6'
      expect(RailsAmp.disable_all?).to eq false
      expect(RailsAmp.enable_all?).to eq false
      expect(RailsAmp.controller_all?('home')).to eq false
      expect(RailsAmp.controller_all?('users')).to eq false
      expect(RailsAmp.controller_actions?('home')).to eq true
      expect(RailsAmp.controller_actions?('users')).to eq true
      expect(RailsAmp.target_actions(UsersController)).to eq ['index']
      expect(RailsAmp.target_actions(HomeController)).to eq ['index', 'about']
      expect(RailsAmp.target?('users', 'index')).to eq true
      expect(RailsAmp.target?('users', 'show')).to eq false
      expect(RailsAmp.target?('home', 'index')).to eq true
      expect(RailsAmp.target?('home', 'help')).to eq false
      expect(RailsAmp.target?('home', 'about')).to eq true
      expect(RailsAmp.amp_format?).to eq false
    end
  end


end
