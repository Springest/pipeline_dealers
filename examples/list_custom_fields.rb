#!/usr/bin/env ruby
require_relative "config"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)

puts "Custom fields for companies:"
custom_fields = client.companies.custom_fields.all.collect do |field|
  [field.name, field.is_required, field.field_type]
end
print_table ["Name", "Required?", "Field type"], custom_fields

puts

puts "Custom fields for people:"
custom_fields = client.people.custom_fields.all.collect do |field|
  [field.name, field.is_required, field.field_type]
end
print_table ["Name", "Required?", "Field type"], custom_fields

