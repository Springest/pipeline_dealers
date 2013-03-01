module PipelineDealers
  module Backend
    class Base
      def cache(key, &block)
        if not @cache.has_key?(key)
          @cache[key] = block.call
        end

        @cache[key]
      end
    end
  end
end
