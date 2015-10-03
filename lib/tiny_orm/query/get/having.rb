module TinyORM
  module Query
    class Having < Condition
      def initialize(query)
        super
        @query.having << self
      end
    end
  end
end
