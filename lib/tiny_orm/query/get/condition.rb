module TinyORM
  module Query
    class Condition < Get
      def initialize(query)
        @conditions = []
        @query = query
      end

      %w(not and or like).each do |method|
        define_method method do |options|
          @conditions << "TinyORM::Query::#{method.capitalize}".constantize.new(@query.table_name, options)
          self
        end
      end

      def compile!
        @conditions.reduce('') do |agg, elem|
          agg << (agg.empty? ? elem.compile! : concat(elem))
        end
      end

      private

      def concat(elem)
        delimiter = elem.is_a?(Or) ? 'OR' : 'AND'
        " #{delimiter} #{elem.compile!}"
      end
    end

    class SimpleCondition < Struct.new(:table_name, :options)
      def compile!
        if options.is_a?(String)
          "(#{options})"
        elsif options.is_a?(Hash)
          build_sql
        else
          options.compile!
        end
      end

      private

      def combine(delimiter = '=')
        options.map do |k, v|
          case v
            when nil
              "#{table_name}.#{k} IS NULL"
            when String
              "#{table_name}.#{k} #{delimiter} '#{v}'"
            when Array
              v_str = v.first.is_a?(Numeric) ? v : v.map{|item| "'#{item}'"}
              "#{table_name}.#{k} IN (#{v_str.join(', ')})"
            when Range
              first, last = v.begin.is_a?(Numeric) ? [v.begin, v.end] : %W('#{v.begin}' '#{v.end}')
              "#{table_name}.#{k} BETWEEN #{first} AND #{last}"
            else
              "#{table_name}.#{k} #{delimiter} #{v}"
          end
        end.join(' AND ')
      end

      def build_sql
        raise NotImplementedError
      end
    end

    class And < SimpleCondition
      def build_sql
        "(#{combine})"
      end
    end

    class Not < SimpleCondition
      def build_sql
        "NOT(#{combine})"
      end
    end

    class Like < SimpleCondition
      def build_sql
        "(#{combine('LIKE')})"
      end
    end

    class Or < SimpleCondition
      def build_sql
        "(#{combine})"
      end
    end
  end
end
