module TinyORM
  module Query
    class Order < Base
      def set(*value)
        @value = *value
        @query.order = self
        self
      end

      def compile!
        return if @value.size.zero?
        (@value.size == 1 && @value.first.is_a?(String)) ? @value.first : group_expression
      end

      private

      def group_expression
        @value.reduce([]) do |order_agg, arg|
          order_agg << (arg.is_a?(Hash) ? expr_by_hash(arg) : expr_simple(arg))
        end.join(', ')
      end

      def expr_simple(arg)
        arg.is_a?(String) ? arg : "#{@query.table_name}.#{arg}"
      end

      def expr_by_hash(arg)
        arg.map do |k, v|
          direction = v.to_sym == :desc ? ' DESC' : ''
          "#{@query.table_name}.#{k}" << direction
        end.join(', ')
      end
    end
  end
end
