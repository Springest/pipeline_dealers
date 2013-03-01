module PipelineDealers
  module Backend
    class Test
      class Collection < Backend::Base::Collection
        extend Delegator

        delegate :count, :first, to: :items

        def initialize(backend, options)
          super(backend, options)
        end

        def find id
          items.select { |model| model.id == id }.first
        end

        def each &operation
          items.each &operation
        end

        def collect &operation
          items.collect &operation
        end

        protected

        def items
          @backend.items[@model_klass]
          @backend.items[@model_klass]
        end
      end
    end
  end
end
