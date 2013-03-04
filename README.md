# Pipelinedealers

API client for pipelinedeals.com

## Installation

Add it to your application's Gemfile:

  ```gem 'pipeline_dealers'```

## Usage

The client's API is modelled after ActiveRecord.

```ruby
require 'pipeline_dealers'

client = Pipelinedealers::Client.new(api_key: "z3kr3tp@zzw0rd")

# Get all companies
client.companies.all.each do |company|
 puts company.name
end

# Find company by ID
my_company = client.companies.find(id)

my_company.name = "foobar"
my_company.save
```

For more details and how to use people and notes, see [the examples](examples/)

## Test your application's usage of pipeline\_dealers.

```ruby
require 'pipeline_dealers'
require 'pipeline_dealers/test'

describe "MyClass" do
  let(:client) { Pipelinedealers::TestClient.new }

  it "should create a company" do
    expect do
      client.companies.create(name: "AwesomeCompany")
    end.to change(client.companies, :length).from(0).to(1)
  end
end
```
*Note:* Be sure to stub the client in your code. This only works if you use the same client reference in both the specs and your application.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks to

The awesome people at

[![Springest](http://static-1.cdnhub.nl/images/logo-springest.jpg "Logo springest.com")](http://www.springest.com/)
