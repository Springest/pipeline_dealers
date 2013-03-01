module PipelineDealers
  module Backend
    class Http
      class Collection < Backend::Base::Collection
        def find id
          status, result = @backend.connection.get(collection_url + "/#{id}.json", {})
          if status == 200
            model_klass.new(collection: self, persisted: true, attributes: result)
          else
            raise Error::NotFound
          end
        end

        def each &operation
          Fetcher.new(@backend.connection, self, model_klass, @options).each do |result|
            operation.call(result)
          end
        end

        def collect &operation
          results = []

          Fetcher.new(@backend.connection, self, model_klass, @options).each do |result|
            results << operation.call(result)
          end

          results
        end
      end
    end
  end
end
