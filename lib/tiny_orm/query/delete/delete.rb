module TinyORM
  module Query
    class Delete
      def initialize(model, conditions)
        @model, @conditions = model, conditions
      end

      def execute
        container = Builder.new(@model)
        container.conditions = @conditions
        container.compile! #TODO execute sql
      end
    end
  end
end
