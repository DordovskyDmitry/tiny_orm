module TinyORM
  module Query
    class Offset < Base
      def set(value)
        @value = value
        @query.offset = self
        self
      end

      def compile!
        @value
      end
    end
  end
end
