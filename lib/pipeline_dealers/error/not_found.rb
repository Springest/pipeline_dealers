module PipelineDealers
  class Error
    class NotFound < Error
      attr_reader :model, :id

      def initialize(model, id)
        @model = model
        @id    = id
        @message = "Could not find a #{@model.inspect} with id #{@id.inspect}"
      end
    end
  end
end
