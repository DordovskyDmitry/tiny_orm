module TinyORM
  module Query
    class Insert
      class Builder
        attr_reader :model, :attributes

        def initialize(model)
          @model = model
          @attributes = {}
        end

        def attributes=(attributes) #TODO Insert multiple
          @attributes = attributes.reduce({fields: [], values: []}) do |agg, (k, v)|
            agg[:fields] << k
            agg[:values] << v
            agg
          end
        end

        def compile!
          raise 'Empty attributes' if attributes[:fields].empty?
          "INSERT INTO #{model.table_name} (#{attributes[:fields].join(', ')}) VALUES (#{attributes[:values].join(', ')})"
        end
      end
    end
  end
end
