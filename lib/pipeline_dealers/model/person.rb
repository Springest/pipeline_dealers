module PipelineDealers
  class Model
    class Person < Model
      include HasCustomFields
      self.collection_url = "people"
      self.attribute_name = "person"

      attrs :first_name,
            :last_name,
            :phone,
            :home_phone,
            :mobile,
            :position,
            :website,
            :email,
            :email2,
            :home_email,
            :company_id,
            :user_id,
            :type,
            :lead_status_id,
            :lead_source_id,
            :predefined_contacts_tag_ids,
            :deal_ids,
            :work_address_1,
            :work_address_2,
            :work_city,
            :work_state,
            :work_country,
            :work_postal_code,
            :home_address_1,
            :home_address_2,
            :home_city,
            :home_state,
            :home_country,
            :home_postal_code,
            :fax,
            :facebook_url,
            :linked_in_url,
            :twitter,
            :instant_message,
            :created_at


      # Read only
      attrs :predefined_contacts_tags,
            :won_deals_total,
            :full_name,
            :company_name,
            :user,
            :lead_status,
            :lead_source,
            :image_thumb_url,
            :predefined_contacts_tags,
            :updated_at,
            :deals,
            :company,
            :viewed_at,
            :total_pipeline,
      read_only: true
    end
  end
end
