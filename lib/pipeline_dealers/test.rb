require "pipeline_dealers"
require "pipeline_dealers/backend/test"

module PipelineDealers
  class TestClient < Client
    def initialize(options = {})
      super(options.merge(backend: Backend::Test))
    end
  end
end
