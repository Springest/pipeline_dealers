module PipelineDealers
  class Error < Exception
    attr_reader :message
    def to_s
      @message
    end
  end
end

require "pipeline_dealers/error/connection"
require "pipeline_dealers/error/custom_field"
require "pipeline_dealers/error/invalid_attribute"
