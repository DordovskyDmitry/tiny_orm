module TinyORM
  module Query
    class Group < Base
      def set(*value)
        @value = *value
        @query.group = self
        self
      end

      def compile!
        return if @value.size.zero?
        (@value.size == 1 && @value.first.is_a?(String)) ? @value.first : group_expression
      end

      private

      def group_expression
        @value.map {|attr| "#{@query.table_name}.#{attr}" }.join(', ')
      end
    end
  end
end
