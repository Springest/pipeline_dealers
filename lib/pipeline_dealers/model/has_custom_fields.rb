require "active_support/concern"

module PipelineDealers
  class Model
    module HasCustomFields

      CUSTOM_FIELD_PREFIX = "custom_label_"
      CUSTOM_FIELD_REGEX  = /#{CUSTOM_FIELD_PREFIX}(\d+)/

      def custom_fields
        @custom_fields
      end

      def process_attributes
        @custom_fields = pld2human_fields(@attributes.delete(:custom_fields))
      end


      def attributes_for_saving attributes
        attributes.merge("custom_fields" => human2pld_fields(@custom_fields))
      end

      protected

      def custom_field_collection
        if @collection.respond_to?(:custom_fields)
          @collection.custom_fields.all
        else
          raise "Expected collection of model '#{@collection.model_klass}' to have the custom field collection (custom_fields method)!"
        end
      end


      def pld2human_fields attributes
        attributes ||= {}
        result = {}

        attributes.each do |key, value|
          field_id = CUSTOM_FIELD_REGEX.match(key)[1].to_i
          field = custom_field_collection.select { |field| field.id == field_id }.first

          raise Error::InvalidAttributeName.new(self, key) if field.nil?
          result[field.name] = field.decode(self, value)
        end

        result
      end

      def human2pld_fields attributes
        attributes ||= {}
        result = HashWithIndifferentAccess.new

        attributes.each do |name, value|
          field = custom_field_collection.select { |field| field.name == name}.first
          raise Error::InvalidAttributeName.new(self, name) if field.nil?
          result[CUSTOM_FIELD_PREFIX + field.id.to_s] = field.encode(self, value)
        end

        result
      end
    end
  end
end
