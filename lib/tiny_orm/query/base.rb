module TinyORM
  module Query
    class Base < Struct.new(:model)
      %w(where having).each do |method|
        define_method method do |options = {}|
          Object.const_get("TinyORM::Query::#{method.capitalize}").new(build_get_query).send(method, options)
        end
      end

      %w(select join group order limit offset).each do |method|
        define_method method do |*value|
          Object.const_get("TinyORM::Query::#{method.capitalize}").new(build_get_query).send(method, *value)
        end
      end

      def update(conditions, attributes)
        where(conditions).update(attributes)
      end

      private

      def build_get_query
        TinyORM::Query::Get::Builder.new(model)
      end
    end
  end
end
