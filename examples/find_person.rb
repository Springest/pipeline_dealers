#!/usr/bin/env ruby
require_relative "config"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)

id = ask_id("Enter the ID of the person you want to find")

person = client.people.find(id)
p person
