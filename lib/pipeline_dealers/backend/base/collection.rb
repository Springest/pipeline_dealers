module PipelineDealers
  module Backend
    class Base
      class Collection
        extend Delegator

        Identity = lambda { |x| x }

        delegate :connection,     to: :backend
        delegate :collection_url, to: :model_klass

        attr_reader :model_klass, :backend, :client

        def initialize(backend, options)
          @options     = options
          @backend     = backend
          @client      = options[:client]      || raise("No client given")
          @model_klass = options[:model_klass] || raise("No :model_klass given")
        end

        def custom_fields
          if @options[:custom_fields]
            @custom_fields ||= @backend.collection(@options[:custom_fields].merge(client: @client))
          else
            raise "Collection of #{@model_klass} doesn not have any custom fields"
          end
        end

        def all
          if use_cache?
            @backend.cache(@options[:cache_key]) { self.to_a }
          else
            self
          end
        end

        def select &block
          results = []

          self.each do |result|
            results << result if block.call(result)
          end

          results
        end

        def collect &operation
          results = []

          self.each do
          end

          results
        end

        def where(condition)
          refine(where: condition)
        end

        def limit(to)
          refine(limit: to)
        end

        def first
          limit(1).collect { |x| return x }
        end

        def to_a
          collect &Identity
        end

        def count
          @backend.count(self)
        end

        def new(attributes = {})
          if @options[:new_defaults]
            attributes = @options[:new_defaults].merge(attributes)
          end

          model_klass.new(collection: self, record_new: true, attributes: attributes)
        end

        def create(attributes = {})
          save(new(attributes))
        end

        def save(model)
          @backend.save(self, model)
          model
        end

        def destroy(model)
          @backend.destroy(self, model)
          model
        end

        protected
        
        # Refine the criterea
        def refine(refinements)
          self.class.new(@backend, @options.merge(refinements))
        end

        def use_cache?
          @options[:cached] == true
        end
      end
    end
  end
end
