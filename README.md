# RailsAmp
Short description and motivation.

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

- app/views/layouts/application.html.erb

```
<%= rails_amp_amphtml_link_tag %>
```

This code will put out the following html header to inform where the amp url is.

```
<link rel="amphtml" href="http://example.com/users/index.amp" />
```


## Usage
How to use my plugin.

You can use `amp?` helper in views.
Use `amp?` helper in your defalut view to switch some codes.

Here is a sample to switch codes for Twitter tweet display.

<% if amp? %>
  <amp-twitter width=486 height=657
      layout="responsive"
      data-tweetid="585110598171631616"
      data-cards="hidden">
      <blockquote placeholder class="twitter-tweet" data-lang="en">*****</blockquote>
  </amp-twitter>
<% else %>
  <blockquote class="twitter-tweet" data-lang="ja">*****</blockquote>
  <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<% end %>


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
