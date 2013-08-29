module PipelineDealers
  module Backend
    class Http
      class Fetcher
        attr_reader :options
        
        # This struct captures the state we need to implement an transparent API
        Cursor = Struct.new(:params, :results_yielded, :done)

        def initialize(connection, collection, model_klass, options)
          @connection  = connection
          @collection  = collection
          @model_klass = model_klass
          @options     = options
        end

        def each(&block)
          cursor = Cursor.new(build_params, 0, false)
          if @collection.collection_url.nil?
            raise "Model #{@model_klass.to_s} doesn't have 'collection_url' value"
          end

          while not cursor.done
            status, result = @connection.get(@collection.collection_url + ".json", cursor.params)

            case status
            when 200 then yield_results(cursor, result, &block)
            when 406 then raise Error::AuthenticationError.new
            else; raise "Unexpected status! #{status.inspect}. Expected 200"
            end
          end
        end

        def build_params
          params = { page: 1, per_page: Limits::MAX_RESULTS_PER_PAGE }

          # Improve efficiency by only fetching as much as we need.
          if requesting_to_many_results?
            params[:per_page] = @options[:limit]
          end

          # Additional condition for filtering
          if @options.has_key?(:where)
            params.merge!(@options[:where])
          end

          params
        end

        def requesting_to_many_results?
          @options[:limit] && @options[:limit] < Limits::MAX_RESULTS_PER_PAGE
        end

        def yield_results cursor, result, &block
          result["entries"].each do |entry|
            block.call(@model_klass.new(client: @collection.client, collection: @collection, persisted: true, attributes: entry))
            cursor.results_yielded += 1

            # Have we reached the limit?
            if options[:limit] && cursor.results_yielded >= options[:limit]
              cursor.done = true
              return
            end
          end

          # Are we on the last page?
          if result["pagination"]["page"] < result["pagination"]["pages"]
            # No, go to next page
            cursor.params[:page] += 1
          else
            # Yes, we're done
            cursor.done = true
          end
        end
      end
    end
  end
end
