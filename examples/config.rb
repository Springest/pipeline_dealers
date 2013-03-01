require "rubygems"
require "bundler"

Bundler.setup

require "pipeline_dealers"

YOUR_API_KEY = ENV["API_KEY"]

if YOUR_API_KEY.nil?
  puts "Run these examples like: "
  puts "  $ API_KEY=<YOUR_API_KEY> bundle exec ./<EXAMPLE>.rb"
  exit
end

def ask_id question
  puts question
  while true
    id = gets.chomp.strip.to_i
    if id < 1
      puts "Invalid id!"
      puts question
    else
      return id
    end
  end
end

def print_table header, rows
  rows     = [header] +rows.map { |row| row.map { |item| item.inspect} }
  maximums = {}
  rows.each do |row| 
    row.each_with_index do |val, idx|
      maximums[idx] = 0 if maximums[idx].nil?

      length = val.length
      maximums[idx] = length if maximums[idx] < length
    end
  end

  format = "|"
  separator="+"
  maximums.keys.sort.each do |idx|
    format    += " %-#{maximums[idx]}s |"
    separator += "-#{'-'*maximums[idx] }-+"
  end

  header = rows.shift
  puts separator
  puts(format % header)
  puts separator
  rows.each { |row| puts(format % row) }
  puts separator
end
