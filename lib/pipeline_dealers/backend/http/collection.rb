module PipelineDealers
  module Backend
    class Http
      class Collection < Backend::Base::Collection
        def find id
          status, result = @backend.connection.get(collection_url + "/#{id}.json", {})
          if status == 200
            model_klass.new(client: @client, collection: self, persisted: true, attributes: result)
          else
            raise Error::NotFound.new(model_klass, id)
          end
        end

        def each &operation
          Fetcher.new(@backend.connection, self, model_klass, @options).each do |result|
            operation.call(result)
          end
        end
      end
    end
  end
end
