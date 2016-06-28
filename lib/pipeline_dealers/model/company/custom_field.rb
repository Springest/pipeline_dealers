module PipelineDealers
  class Model
    class Company
      class CustomField < Model::CustomField
        self.collection_url = "admin/company_custom_field_labels"

        attrs :custom_field_group_id,
          readonly: true
      end
    end
  end
end
