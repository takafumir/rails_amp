require 'rails/generators'

module RailsAmp
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def inject_amp_mime_type_into_file
      inject_into_file 'config/initializers/mime_types.rb',
                            after: %Q(# Mime::Type.register "text/richtext", :rtf\n) do <<-'RUBY'
Mime::Type.register_alias 'text/html', RailsAmp.default_format
RUBY
      end
    end

    def create_config_yaml_file
      copy_file 'rails_amp.yml', 'config/rails_amp.yml'
    end
  end
end
