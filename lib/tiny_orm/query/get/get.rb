module TinyORM
  module Query
    class Get
      def initialize(query)
        @query = query
      end

      %w(where having).each do |method|
        define_method method do |options = {}|
          klass = "TinyORM::Query::#{method.capitalize}".constantize
          self.is_a?(klass) ? self.and(options) : klass.new(@query).and(options)
        end
      end

      %w(select join group order limit offset).each do |method|
        define_method method do |*value|
          "TinyORM::Query::#{method.capitalize}".constantize.new(@query).set(*value)
        end
      end

      def all
        # query_string = @query.compile!
        # connection.execute(query_string)
      end

      def each

      end

      def first

      end

      def last

      end

      def count
        @query.select = 'count(*)'
        # query_string = @query.compile!
        # connection.execute(query_string)
      end

      def to_sql
        @query.compile!
      end
    end
  end
end
