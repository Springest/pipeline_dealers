#!/usr/bin/env ruby
require_relative "config"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)
company = client.companies.create(name: "Awesome Company")
company.name = "blah"

company.save
puts "Created company #{company.name}, with id #{company.id}"

company.destroy
puts "And destroyed it"
