module PipelineDealers
  module Backend
    class Test < Base
      attr_reader :items

      def cache key
        yield
      end

      def initialize(client)
        @client = client
        @items = Hash.new
        @last_id = 41
      end

      def collection(options)
        Collection.new(self, options)
      end

      def save(collection, model)
        super

        @items[model.class] ||= []
        @items[model.class] << model

        if model.id.nil?
          model.send(:instance_variable_set, :@id, @last_id += 1)
        end
      end

      def destroy(collection, to_remove)
        if @items.has_key?(to_remove.class)
          @items[to_remove.class].reject! { |model| model == to_remove }
        end
      end
    end
  end
end
