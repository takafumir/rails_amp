class RailsAmpGenerator < Rails::Generators::Base
  def inject_amp_mime_type_into_file
    inject_into_file 'config/initializers/mime_types.rb', after: %Q(# Mime::Type.register "text/richtext", :rtf\n) do <<-'RUBY'
Mime::Type.register_alias 'text/html', :amp
RUBY
    end
  end

  def create_config_yaml_file
    create_file 'config/rails_amp.yml', <<-FILE
# ### Here is a sample to enable amp on controller actions
# ### enable amp on users all actions
# users:
#
# ### enable amp on users#index, users#show, posts#index, posts#show
# ### controller_name: action1 action2 action3 ...
# users: index show
# posts: index show
#
# ### enable amp on all controllers and actions
# application:
FILE
  end
end
