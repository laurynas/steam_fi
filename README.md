# SteamFi

steam.fi SMS gateway client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'steam_fi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install steam_fi

## Usage

Add configuration to the initializer: `config/initializers/steam_fi.rb`

```ruby
SteamFi::API.setup(
  :username => 'someuser', 
  :password => 'somepassword'
)
```

Send SMS:

```ruby
SteamFi::API.send_sms('1234PHONE', 'Hello world')
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/steam_fi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
