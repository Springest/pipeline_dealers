#!/usr/bin/env ruby
require_relative "config"
require "debugger"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)

id = ask_id("Enter the ID of the company")

company = client.companies.find(id)

attributes = PipelineDealers::Model::Company.attributes.collect do |attribute, options|
  [attribute, options, company.attributes[attribute]]
end

print_table ["Name", "Options", "Value"], attributes

puts

puts "Custom fields of this company:"
print_table ["Name", "Value"], company.custom_fields.collect { |k,v| [k,v] }
