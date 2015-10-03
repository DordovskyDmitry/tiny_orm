module TinyORM
  module Query
    class Limit < Get
      def set(value)
        @value = value
        @query.limit = self
        self
      end

      def compile!
        @value
      end
    end
  end
end
