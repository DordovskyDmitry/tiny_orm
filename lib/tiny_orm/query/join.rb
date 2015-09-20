module TinyORM
  module Query
    class Join < Base
      def set(value)
        @value = value
        @query.join << self
        self
      end

      def compile!
        (@value.is_a?(String) && @value.match('join')) ? @value : join_table(@value)
      end

      private

      def join_table(table)
        raise NotImplementedError
      end
    end
  end
end