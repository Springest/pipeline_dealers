module PipelineDealers
  class Model
    class Company
      class CustomField < Model::CustomField
        self.collection_url = "admin/company_custom_field_labels"
      end
    end
  end
end
