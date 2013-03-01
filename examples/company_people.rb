#!/usr/bin/env ruby
require_relative "config"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)

client.companies.each do |company|
  puts "Company: " + company.name
  puts "People:"

  company.people.each do |person|
    puts "  - " + person.full_name
  end

  puts
end
