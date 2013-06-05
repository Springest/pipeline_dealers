module PipelineDealers
  class Model
    class Note < Model
      self.collection_url = "notes"
      self.attribute_name = "note"

      attrs :deal_id,
            :person_id,
            :user_id,
            :company_id,
            :title,
            :created_by_user_id,
            :created_by_user,
            :note_category_id,
            :content,
            :note_category

      # Read only
      attrs :created_at, 
            :updated_at,
            :deal,
            :person,
            :company,
            :user,
            :user,
            :comments,
            :possible_notify_user_ids,
            :notify_user_ids,
        read_only: true

      alias_method :person_cache,  :person
      alias_method :company_cache, :company

      def person
        @client.people.find(self.person_id)
      end

      def company
        @client.companies.find(self.company_id)
      end
    end
  end
end
