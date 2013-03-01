module PipelineDealers
  class Model
    class Person 
      class CustomField < Model::CustomField
        self.collection_url = "admin/person_custom_field_labels"
      end
    end
  end
end
