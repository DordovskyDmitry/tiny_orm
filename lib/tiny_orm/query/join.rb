module TinyORM
  module Query
    class Join < Base
      attr_reader :type

      def set(*value)
        @type, @value = %w(inner left right).include?(value.first.to_s) ? [value.first, value.drop(1)] : [:inner, value]
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

      def expr_simple(arg)
        association = @query.model.associations(arg)
        association.path.map do |assoc|
          owner, target = assoc.owner, assoc.target
          "#{@type.to_s.upcase} JOIN #{target.table_name} ON #{owner.table_name}.#{assoc.internal_key} = #{target.table_name}.#{assoc.external_key}"
        end.join(' ')
      end

      #TODO Implement  different relations (not only many-to-many) and deeper case
      def expr_by_hash(arg)
        arg.map do |k, v|
          association = @query.model.associations(k)
          association2 = association.target.associations(v)

          s1 = association.path.map do |assoc|
            owner, target = assoc.owner, assoc.target
            "#{@type.to_s.upcase} JOIN #{target.table_name} ON #{owner.table_name}.#{assoc.internal_key} = #{target.table_name}.#{assoc.external_key}"
          end.join(' ')

          s2 = association2.path.map do |assoc|
            owner, target = assoc.owner, assoc.target
            "#{@type.to_s.upcase} JOIN #{target.table_name} ON #{owner.table_name}.#{assoc.internal_key} = #{target.table_name}.#{assoc.external_key}"
          end.join(' ')

          s1 + ' ' + s2

        end.join(' ')
      end
    end
  end
end
