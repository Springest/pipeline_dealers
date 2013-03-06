module PipelineDealers
  module Backend
    class Http < Base
      attr_reader :connection

      def initialize(options)
        @cache      = {}
        @options    = options
        @connection = Connection.new(@options)
      end

      def collection(options)
        Collection.new(self, options)
      end

      def save(collection, model)
        super

        model_attr_name = model.class.attribute_name

        if model_attr_name.nil?
          raise "Model #{model.class} doesn't have a attribute_name field"
        end

        # Use :post for new records, :put for existing ones
        method = model.new_record? ? :post : :put

        status, response = @connection.send(method, model_url(collection, model), model_attr_name  => model.save_attrs)

        case status
          when 200 then 
            model.send(:import_attributes!, response) # Update with server side copy
            model.send(:instance_variable_set, :@persisted, true) # Mark as persisted
          when 422 then handle_errors_during_save(response)
          else;         raise "Unexepcted response status #{status.inspect}"
        end

        self
      end

      def destroy(collection, model)
        state, response = @connection.delete(model_url(collection, model), {})
        if (state == 200)
          model.send(:instance_variable_set, :@persisted, false) # Mark as persisted
          model
        else
          raise "Could not remove"
        end
      end

      def model_url(collection, model)
        if model.persisted?
          collection.send(:collection_url) + "/" + model.id.to_s + ".json"
        else
          collection.send(:collection_url) + ".json"
        end
      end

      protected

      def handle_errors_during_save(response)
        raise response.collect { |error| "field '#{error["field"]}' #{error["msg"]}" }.join(" and ").capitalize
      end
    end
  end
end
