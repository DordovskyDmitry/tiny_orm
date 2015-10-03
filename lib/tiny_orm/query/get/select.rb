module TinyORM
  module Query
    class Select < Get
      def set(*value)
        @value = *value
        @query.select = self
        self
      end

      def compile!
        return '*' if @value.size.zero?
        (@value.size == 1 && @value.first.is_a?(String)) ? @value.first : select_expression
      end

      def select_expression
        @value.map {|attr| attr.is_a?(String) ? attr : "#{@query.table_name}.#{attr}" }.join(', ')
      end
    end
  end
end
