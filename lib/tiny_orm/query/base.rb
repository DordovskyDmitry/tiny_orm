module TinyORM
  module Query
    class Base
      def initialize(query)
        @query = query
      end

      def where(options = {})
        (self.class == Where) ? self.and(options) : Where.new(@query).and(options)
      end
    end
  end
end
