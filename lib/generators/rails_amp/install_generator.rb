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

    def create_config_file
      copy_file 'rails_amp.yml', 'config/rails_amp.yml'
    end

    def create_application_layout
      copy_file 'rails_amp_application.amp.erb', 'app/views/layouts/rails_amp_application.amp.erb'
    end
  end
end
