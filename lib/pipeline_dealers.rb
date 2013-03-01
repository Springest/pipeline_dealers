require "pipeline_dealers/version"

module PipelineDealers
  require "pipeline_dealers/delegator"

  require "pipeline_dealers/limits"
  require "pipeline_dealers/error"
  require "pipeline_dealers/client"

  # Base model
  require "pipeline_dealers/model"
  require "pipeline_dealers/model/custom_field"
  require "pipeline_dealers/model/has_custom_fields"

  # Models
  require "pipeline_dealers/model/company"
  require "pipeline_dealers/model/company/custom_field"
  require "pipeline_dealers/model/person"
  require "pipeline_dealers/model/person/custom_field"
  require "pipeline_dealers/model/note"



  require "pipeline_dealers/backend/base"
  require "pipeline_dealers/backend/http"
end
