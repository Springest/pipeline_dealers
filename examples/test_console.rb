#!/usr/bin/env ruby
require "rubygems"
require "bundler"
require "irb"

Bundler.setup

require "pipeline_dealers"
require "pipeline_dealers/test"

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
  def test_client
    @test_client ||= PipelineDealers::TestClient.new
  end
end


puts "You can access the test_client with 'test_client'."
IRB.start_session(Context)
