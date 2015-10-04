module TinyORM
  module Query
    class Delete
      class Builder
        attr_reader :model
        attr_accessor :conditions

        def initialize(model)
          @model = model
          @conditions = []
        end

        def compile!
          "#{delete_expression} #{conditions_expression}".strip
        end

        private

        def delete_expression
          "DELETE FROM #{model.table_name}"
        end

        def conditions_expression
          "WHERE #{conditions.map(&:compile!).join(' AND ')}" if conditions.any?
        end
      end
    end
  end
end
