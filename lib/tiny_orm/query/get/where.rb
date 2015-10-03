module TinyORM
  module Query
    class Where < Condition
      def initialize(query)
        super
        @query.where << self
      end
    end
  end
end
