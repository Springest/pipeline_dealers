#!/usr/bin/env ruby
require_relative "config"
require "irb"

# Hack to force context
module IRB
  def self.start_session(binding)
    unless @__initialized
      args = ARGV
      ARGV.replace(ARGV.dup)
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end
    workspace = WorkSpace.new(binding)
    irb = Irb.new(workspace)
    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end


module Context
  extend self
  def client
    @client ||= PipelineDealers::Client.new(api_key: YOUR_API_KEY)
  end
end


puts "You can access the client with 'client'."
IRB.start_session(Context)
