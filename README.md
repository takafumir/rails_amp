# RailsAmp

RailsAmp is a Ruby on Rails plugin that makes it easy to build views for AMP(Accelerated Mobile Pages).

## Installation

In your Gemfile:

```ruby
gem 'rails_amp'
```

And install:

```bash
$ bundle install
```

And then, generate codes and files:

```bash
$ rails generate rails_amp:install
```

This step generates the followings.

```bash
insert  config/initializers/mime_types.rb
create  config/rails_amp.yml
create  app/views/layouts/rails_amp_application.amp.erb
```

In config/initializers/mime_types.rb:

```ruby
Mime::Type.register_alias 'text/html', RailsAmp.default_format
```

This line must be added to enable rails to recognize amp default format. The default foramt is :amp. You can change the amp default format in config/rails_amp.yml

## Setup

Add the following code in your default layout head like `application.html.erb`.

In app/views/layouts/application.html.erb:

```html
<%= rails_amp_amphtml_link_tag %>
```

This code will put out the html header to inform where the amp url is.

```html
<link rel="amphtml" href="http://example.com/users.amp" />
```

## Configurations

You can change RailsAmp configurations in your `config/rails_amp.yml`. Write configs with yaml.

In config/rails_amp.yml:

```yaml
# ### Here are some config samples to use rails_amp.

# --------------------------------------------------
# To enable amp on specific controllers and actions.
# --------------------------------------------------
# ### Enable amp on users all actions.
# targets:
#   users:
#
# ### Enable amp on users#index, users#show, posts#index, posts#show.
# ### controller: action1 action2 action3 ...
# targets:
#   users: index show
#   posts: index show
#
# ### Enable amp on all controllers and actions.
# targets:
#   application: all
#
# ### Disable amp completely.
# targets:
#
targets:
  users: index show

# --------------------------------------------------
# To set initial configurations.
# --------------------------------------------------
# ### Enable Google Analytics page tracking. Set your Google Analytics Account.
# analytics: UA-*****-*
#
# ### Change default amp format. The default value is amp.
# ### If you want to use 'mobile' as amp format, set 'mobile' to default_format.
# ### And you can access the amp page like /users/index.mobile
# default_format: mobile
#
# ### Set formats that used as amp. The default is html.
# ### These formats are used in the order, when the amp specialized view like 'users/index.amp.erb' is not found.
# lookup_formats: html xhtml
```

#### Examples

Set the controllers and actions that you want to enable amp.

Enable amp on users all actions.

```yaml
targets:
  users:
```

Enable amp on some specific controllers and actions. e.g.) users#index, users#show, posts#index, posts#show.

```yaml
targets:
  users: index show
  posts: index show
```

Enable amp on all controllers and actions. (It's a bit dangerous, so I don't recommend.)

```yaml
targets:
  application: all
```

Disable amp completely.

```yaml
targets:
```

Other configurations.

Enable Google Analytics page tracking. Set your Google Analytics Account.

```yaml
analytics: UA-*****-*
```

Change the amp default format. The default value is 'amp'. If you want to use 'mobile' as the default format, set 'mobile' to default_format. And you can access the amp page like `http://example.com/users.mobile`.

```yaml
default_format: mobile
```

Change formats that used as amp. The default is html. These formats are used in the order, when the amp specialized view like `app/views/users/index.amp.erb` is not found.

```yaml
lookup_formats: html xhtml
```

## Customize AMP layout

In app/views/layouts/rails_amp_application.amp.erb:

```html
<!doctype html>
<html amp>
  <head>
    <meta charset="utf-8">
    <title>Rails AMP</title>
    <link rel="canonical" href="<%= rails_amp_canonical_url %>" />
    <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">

    <!-- Set page data type by JSON-LD and schema.org. -->
    <!-- If you don't use page data type, remove this block. -->
    <script type="application/ld+json">
      {
        "@context": "http://schema.org",
        "@type": "*****",
        "mainEntityOfPage": "*****",
        "datePublished": "*****"
      }
    </script>

    <!-- Write custom css sytle for amp html here. -->
    <style amp-custom>
      body {
      }
      amp-img {
      }
    </style>

    <%= rails_amp_google_analytics_page_tracking %>
    <%= rails_amp_html_header %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

Customize the page data type by JSON-LD and schema.org, and write custom css styles in `<style amp-custom>` block. You can customize any other parts of this amp layout file as you like, but you need to follow the amp restrictions.

## Usage

To access amp pages, add the amp default format at the end of the url before queries like the followings.

```
http://example.com/users.amp
http://example.com/users.amp?sort=name
```

If you change the amp default format, you have to use it as the format.

In your config/rails_amp.yml

```yaml
default_format: mobile
```

Access the amp pages.

```
http://example.com/users.mobile
http://example.com/users.mobile?sort=name
```

#### When not creating another view for amp. (When the template for amp not found)

If you don't create another view for amp (When the template for amp not found), RailsAmp tries to find amp-available formats accoding to the config `lookup_formats`, and uses the existing html view for the amp page as is.

e.g.) When you enable amp on `users#index` in config and don't create another amp view like `app/views/users/index.amp.erb`, RailsAmp uses the existing html view like `app/views/users/index.html.erb` for the amp page.

Then, you can access the amp page as `http://example.com/users.amp` by adding the amp default format at the end of the url before queries.

#### When creating another view for amp.

If you want to use specialized views for amp pages, you can create another view for amp like `app/views/users/index.amp.erb`. When accessing `http://example.com/users.amp` and the amp template found, the amp specialized view will be used.

If you change the amp default format, create the view template with the format.

In config/rails_amp.yml:

```yaml
default_format: mobile
```

Create the view template as `app/views/users/index.mobile.erb`, and access the amp page as `http://example.com/users.mobile`.

#### View Helpers

You can use a helper `amp_renderable?` in views. Use `amp_renderable?` in your existing html views to switch some codes. Here is a sample to switch codes for Twitter tweet display.

```html
<% if amp_renderable? %>
  <!-- For amp -->
  <amp-twitter width=486 height=657
      layout="responsive"
      data-tweetid="*****"
      data-cards="hidden">
      <blockquote placeholder class="twitter-tweet" data-lang="en">*****</blockquote>
  </amp-twitter>
<% else %>
  <!-- For normal html -->
  <blockquote class="twitter-tweet" data-lang="ja">*****</blockquote>
  <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<% end %>
```

## Check AMP validation

In Google Chrome browser:

1. Start the Developer Tools.
1. Select the Console tab.
1. Access the amp page with `#development=1` like `http://localhost:3000/users.amp#development=1`

If `AMP validation successful` shows, the amp page is valid. If some errors are detected, fix your existing html view using the `amp_renderable?` helper or create another amp specialized view.

## References

[Accelerated Mobile Pages Project](https://www.ampproject.org/)

## Contributing

1. Fork it ( https://github.com/takafumir/rails_amp/fork )
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/takafumir/rails_amp/blob/master/MIT-LICENSE).

## Author

[Takafumi Yamano](https://github.com/takafumir)
