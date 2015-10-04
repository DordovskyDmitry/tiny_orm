module TinyORM
  module Query
    class Base < Struct.new(:model)
      %w(where having).each do |method|
        define_method method do |options = {}|
          query_object(method).send(method, options)
        end
      end

      %w(select join group order limit offset).each do |method|
        define_method method do |*value|
          query_object(method).send(method, *value)
        end
      end

      def update(conditions, attributes)
        where(conditions).update(attributes)
      end

      def insert(options)
        Insert.new(model, options).execute
      end

      def delete(conditions)
        where(conditions).delete
      end

      private

      def query_object(method)
        "TinyORM::Query::#{method.capitalize}".constantize.new(build_get_query)
      end

      def build_get_query
        TinyORM::Query::Get::Builder.new(model)
      end
    end
  end
end
