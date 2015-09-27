module TinyORM
  module Query
    class Join < Base
      def set(*value)
        @value = *value
        @query.join << self
        self
      end

      def compile!
        return if @value.size.zero?
        (@value.size == 1 && @value.first.is_a?(String) && @value.first.match(/\bjoin\b/i)) ? @value.first : join_expression
      end

      private

      def join_expression
        @value.reduce([]) do |join_agg, arg|
          join_agg << (arg.is_a?(Hash) ? expr_by_hash(arg) : expr_simple(arg))
        end.join(' ')
      end

      #TODO Implement different relations
      def expr_simple(arg)
        "INNER JOIN #{arg} ON #{@query.table_name}.id = #{arg}.#{@query.table_name.singularize}_id"
      end

      #TODO Implement  different relations (not only many-to-many) and deeper case
      def expr_by_hash(arg)
        arg.map do |k, v|
          "INNER JOIN #{k} ON #{@query.table_name}.id = #{k}.#{@query.table_name.singularize}_id INNER JOIN #{v} ON #{v}.id = #{k}.#{v.to_s.singularize}_id"
        end.join(' ')
      end
    end
  end
end