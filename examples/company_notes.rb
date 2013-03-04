#!/usr/bin/env ruby
require_relative "config"

client = PipelineDealers::Client.new(api_key: YOUR_API_KEY)

client.companies.each do |company|
  puts "Company: " + company.name
  puts "Notes:"

  company.notes.each do |note|
    puts "Title      : #{note.title}"
    puts "  - Person : #{note.person.full_name}" if note.person_id != nil
    puts "  - Content: #{note.content.gsub("\n","\n             ")}"
  end

  puts
end
