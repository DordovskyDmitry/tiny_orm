module TinyORM
  module Query
    class Insert
      attr_reader :model, :attributes

      def initialize(model, attributes)
        @model, @attributes = model, attributes
      end

      def execute
        container = Insert::Builder.new(model)
        container.attributes = attributes
        container.compile! #TODO execute sql
      end
    end
  end
end
