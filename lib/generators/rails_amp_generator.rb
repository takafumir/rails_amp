class RailsAmpGenerator < Rails::Generators::Base
  def inject_amp_mime_type_into_file
    inject_into_file 'config/initializers/mime_types.rb', after: %Q(# Mime::Type.register "text/richtext", :rtf\n) do <<-'RUBY'
Mime::Type.register_alias 'text/html', :amp
RUBY
    end
  end
end
