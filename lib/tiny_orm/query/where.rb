module TinyORM
  module Query
    class Where < Base
      class Condition < Struct.new(:table_name, :options)
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
            if v.nil?
              "#{table_name}.#{k} IS NULL"
            elsif v.is_a?(String)
              "#{table_name}.#{k} #{delimiter} '#{v}'"
            else
              "#{table_name}.#{k} #{delimiter} #{v}"
            end
          end.join(' AND ')
        end

        def build_sql
          raise NotImplementedError
        end
      end

      class And < Condition
        def build_sql
          "(#{combine})"
        end
      end

      class Not < Condition
        def build_sql
          "NOT(#{combine})"
        end
      end

      class Like < Condition
        def build_sql
          "(#{combine('LIKE')})"
        end
      end

      class Or < Condition
        def build_sql
          "(#{combine})"
        end
      end

      def initialize(query)
        @conditions = []
        @query = query
        @query.where << self
      end

      %w(not and or like).each do |method|
        define_method method do |options|
          @conditions << Object.const_get("TinyORM::Query::Where::#{method.capitalize}").new(@query.table_name, options)
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
  end
end
