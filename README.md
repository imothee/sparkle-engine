# Twinkle

Twinkle makes it easy to serve up an appcast xml feed and to store anonymized and aggregated Sparkle Framework statistics.

## Usage

You can easily mount Twinkle to manage and serve your Appcast and store and summarize statistics.

Twinkle contains 5 models, an appcast controller and a summarize concern for creating aggregate usage statistics.

Too much trouble hosting your own? Check out [appable.xyz](https://appable.xyz)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twinkle"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install twinkle
```

## Install the migrations

```bash
bin/rails twinkle:install:migrations
```

## Mount the routes

Add the folllwing to your config/routes

```
mount Twinkle::Engine => "/"
```

This will mount the appcast routes at /updates/:app.slug

## Extending Twinkle Apps

You can extend the Twinkle::App model by creating app/models/twinkle/app.rb

```ruby
class Twinkle::App < ApplicationRecord
  include Twinkle::Concerns::Models::App
  include Summarize

  # Your custom app code and validations etc go here
end
```

## Contributing

Pull requests welcome.

## Testing

```bash
bin/rails db:test:prepare
bin/test
```

## Building the gem

```bash
gem build
gem push twinkle-x.x.x.gem
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
