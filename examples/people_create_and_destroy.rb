#!/usr/bin/env ruby
require_relative "config"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)
person = client.people.create(first_name: "Maarten", last_name: "Hoogendoorn")
person.destroy
