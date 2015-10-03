module TinyORM
  module Query
    class Update
      def initialize(model, conditions, attributes)
        @model, @conditions, @attributes = model, conditions, attributes
      end

      def execute
        container = Builder.new(@model)
        container.conditions = @conditions
        container.attributes = @attributes
        container.compile! #TODO execute sql
      end
    end
  end
end
