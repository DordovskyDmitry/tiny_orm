module TinyORM
  module Query
    class Base
      def initialize(query)
        @query = query
      end

      def all
        # query_string = @query.compile!
        # connection.execute(query_string)
      end

      def to_sql
        @query.compile!
      end

      %w(where having).each do |method|
        define_method method do |options = {}|
          klass = Object.const_get("TinyORM::Query::#{method.capitalize}")
          self.is_a?(klass) ? self.and(options) : klass.new(@query).and(options)
        end
      end

      %w(select join group order limit offset).each do |method|
        define_method method do |*value|
          Object.const_get("TinyORM::Query::#{method.capitalize}").new(@query).set(*value)
        end
      end

      def count
        @query.select = 'count(*)'
        # query_string = @query.compile!
        # connection.execute(query_string)
      end
    end
  end
end
