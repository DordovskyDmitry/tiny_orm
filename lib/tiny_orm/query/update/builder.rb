module TinyORM
  module Query
    class Update
      class Builder
        attr_reader :model, :attributes
        attr_accessor :conditions

        def initialize(model)
          @model = model
          @conditions = []
          @attributes = {}
        end

        def attributes=(attributes)
          @attributes = attributes.reduce({fields: [], values: []}) do |agg, (k, v)|
            agg[:fields] << k
            agg[:values] << v
            agg
          end
        end

        def compile!
          raise 'Empty attributes' if attributes[:fields].empty?
          "#{update_expression} #{conditions_expression}".strip
        end

        private

        def update_expression
          "UPDATE #{model.table_name} SET (#{attributes[:fields].join(', ')}) VALUES (#{attributes[:values].join(', ')})"
        end

        def conditions_expression
          "WHERE #{conditions.map(&:compile!).join(' AND ')}" if conditions.any?
        end
      end
    end
  end
end
