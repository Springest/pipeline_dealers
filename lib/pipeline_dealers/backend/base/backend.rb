module PipelineDealers
  module Backend
    class Base
      def cache(key, &block)
        if not @cache.has_key?(key)
          @cache[key] = block.call
        end

        @cache[key]
      end

      # This base version just sets the condition fields from the collection
      # to the model, if they're not set manually
      def save(collection, model)
        if collection.options.has_key?(:where)
          collection.options[:where].each do |field, value|
            if model.send(field).nil?
              setter = :"#{field}="
              model.send(setter, value)
            end
          end
        end
      end
    end
  end
end
