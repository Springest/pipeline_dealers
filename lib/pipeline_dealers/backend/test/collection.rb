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

        protected

        def items
          if @options.has_key?(:limit)
            filtered_items[0..(@options[:limit]-1)]
          else
            filtered_items
          end
        end

        def filtered_items
          if not @options.has_key?(:where)
            @backend.items[@model_klass] || []
          else
            (@backend.items[@model_klass] || []).select do |model|
              res = @options[:where].detect do |field, value| # 'return' true when a condition does NOT hold
                if !@model_klass.attributes.has_key?(field) && field != :id
                  raise("Model #{@model_klass} doesn't have a field #{field.inspect}")
                else
                  model.send(field) != value
                end
              end
              res == nil # All conditions did hold
            end
          end
        end
      end
    end
  end
end
