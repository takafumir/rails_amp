# RailsAmp
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_amp'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_amp
```


Add header code in your default layout like application.html.erb.

#### app/views/layouts/application.html.erb

```
<%= link_rel_amphtml %>
```

This code will put out the following html header to inform where the amp url is.

```
<link rel="amphtml" href="http://example.com/users/index.amp" />
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
