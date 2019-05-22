# 24SevenOffice Ruby API wrapper

Please see https://24SevenOffice.com for more information. API Documentation can be found at http://developer.24sevenoffice.com.

You need an ApplicationID from 24SevenOffice to use the API in addition to API credentials.

Sorry for the lack of tests. It was a bit tedious to modify internal tests with sensitive responses to this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tfso'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tfso

## Usage

```
tfso_auth = TFSO::Authentication.new(APPLICATION_ID)
tfso_auth.authenticate(
  USERNAME,
  PASSWORD,
  IDENTIDY_ID
)
puts tfso_auth.identities

tfso_company = TFSO::Company.new(tfso_auth)
company_attributes = {
  name: 'Inspired AS',
  email: 'espen@inspired.no',
  tfso: {
    DistributionMethod: 'EMail'
  }
}
company = tfso_company.create(tfso_company.transform_attributes(company_attributes))
puts company[:id]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

When using this gem in a Rails project within the development environment it is set up to use a local proxy at http://localhost:8080 to inspect traffic. A local proxy can be set up using https://mitmproxy.org.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/espen/tfso.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
