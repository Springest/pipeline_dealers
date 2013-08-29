module PipelineDealers
  class Error
    class AuthenticationError < Error::Connection
      attr_reader :errors

      def initialize
        @message = "Wrong API key"
      end
    end
  end
end
