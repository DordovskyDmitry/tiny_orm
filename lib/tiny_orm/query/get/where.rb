module TinyORM
  module Query
    class Where < Condition
      def initialize(query)
        super
        @query.where << self
      end

      def update(attributes)
        Update.new(@query.model, @query.where, attributes).execute
      end
    end
  end
end
