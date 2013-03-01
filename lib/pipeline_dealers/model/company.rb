module PipelineDealers
  class Model
    class Company < Model
      include HasCustomFields
      self.collection_url = "companies"
      self.attribute_name = "company"

      attrs :name,
            :description,
            :email,
            :web,
            :fax,
            :address_1,
            :address_2,
            :city,
            :postal_code,
            :country,
            :phone1,
            :phone2,
            :phone3,
            :phone4,
            :phone1_desc,
            :phone2_desc, :phone3_desc,
            :phone4_desc,
            :created_at,
            :import_id


      # Read only
      attrs :won_deals_total, 
            :image_thumb_url,
            :updated_at,
            :total_pipeline,
            :state,
        read_only: true

      def people
        @client.people.where(company_id: self.id)
      end

      def notes
        @client.notes.where(company_id: self.id)
      end
    end
  end
end
