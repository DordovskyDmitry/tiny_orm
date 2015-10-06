module TinyORM
  module Query
    class Join < Get
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
        @value.reduce([]) { |join_agg, arg| join_agg << complex_expression(@query.model, arg) }.join(' ')
      end

      def complex_expression(model, associations)
        if associations.is_a?(Hash)
          hash_expression(model, associations)
        elsif associations.is_a?(Array)
          array_expression(model, associations)
        else
          simple_expression(model, associations)
        end
      end

      def hash_expression(model, associations)
        associations.keys.reduce([]) do |agg, key|
          key_model = model.associations(key).target
          agg << simple_expression(model, key) << complex_expression(key_model, associations[key])
        end.join(' ')
      end

      def array_expression(model, associations)
        associations.reduce([]) { |agg, key| agg << complex_expression(model, key) }.join(' ')
      end

      def simple_expression(k, v)
        association = k.associations(v)
        association.path.map do |assoc|
          owner, target = assoc.owner, assoc.target
          "#{@type.to_s.upcase} JOIN #{target.table_name} ON #{owner.table_name}.#{assoc.internal_key} = #{target.table_name}.#{assoc.external_key}"
        end.join(' ')
      end
    end
  end
end
