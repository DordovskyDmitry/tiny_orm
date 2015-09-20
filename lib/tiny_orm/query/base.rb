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

      def where(options = {})
        self.is_a?(Where) ? self.and(options) : Where.new(@query).and(options)
      end

      def having(options = {})
        self.is_a?(Having) ? self.and(options) : Having.new(@query).and(options)
      end

      def join(table)
        Join.new(@query).set(table)
      end

      def group(expression)
        Group.new(@query).set(expression)
      end

      def limit(quantity)
        Limit.new(@query).set(quantity)
      end

      def offset(quantity)
        Limit.new(@query).set(quantity)
      end

      def count
        @query.select = 'count(*)'
        # query_string = @query.compile!
        # connection.execute(query_string)
      end
    end
  end
end
