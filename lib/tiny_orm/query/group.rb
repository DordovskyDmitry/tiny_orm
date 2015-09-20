module TinyORM
  module Query
    class Group < Base
      def set(value)
        @value = value
        @query.group << self
        self
      end

      def compile!

      end
    end
  end
end
