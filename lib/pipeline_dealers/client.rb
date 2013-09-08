module PipelineDealers
  # This class models the API client.
  class Client
    attr_reader :api_key
    attr_reader :backend

    def initialize(options = {})
      @backend = (options.delete(:backend) || Backend::Http).new(options)
    end

    def companies
      @companies ||= @backend.collection(client: self, model_klass: Model::Company, custom_fields: { model_klass: Model::Company::CustomField, cached: true, cache_key: "custom_company_fields" })
    end

    def people
      @people ||= @backend.collection(client: self, model_klass: Model::Person, custom_fields: {model_klass: Model::Person::CustomField, cached: true, cache_key: "custom_person_fields"})
    end

    def notes
      @notes ||= @backend.collection(client: self, model_klass: Model::Note)
    end

    def custom_field_label_dropdown_entries
      @dropdown_options ||= @backend.collection(client: self, model_klass: Model::CustomField::DropdownEntry, cache: true)
    end
  end
end
