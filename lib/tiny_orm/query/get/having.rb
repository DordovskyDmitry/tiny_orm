module TinyORM
  module Query
    class Having < Where
      def initialize(query)
        @conditions = []
        @query = query
        @query.having << self
      end
    end
  end
end
