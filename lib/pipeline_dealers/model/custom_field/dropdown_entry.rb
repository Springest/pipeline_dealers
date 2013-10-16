module PipelineDealers
  class Model
    class CustomField
      class DropdownEntry < Model
        self.collection_url = "admin/custom_field_label_dropdown_entries"
        attrs :position, :custom_field_label_id, :name, :created_at, :updated_at
      end
    end
  end
end
