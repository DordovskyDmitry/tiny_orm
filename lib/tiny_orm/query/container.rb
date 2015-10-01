module TinyORM
  module Query
    class Container
      attr_reader :model
      attr_accessor :select, :where, :join, :order, :limit, :offset, :group, :having

      def initialize(model)
        @model = model
        @where = []
        @join = []
        @having = []
      end

      def table_name
        model.table_name
      end

      def compile!
        sql = <<SQL
          #{select_expression}
          #{from_expression}
          #{join_expression}
          #{where_expression}
          #{group_expression}
          #{having_expression}
          #{order_expression}
          #{limit_expression}
          #{offset_expression}
SQL
        sql.gsub(/\s+/, ' ').strip
      end

      private

      def select_expression
        "SELECT #{select ? select.compile! : '*'}"
      end

      def from_expression
        "FROM #{model.table_name}"
      end

      def join_expression
        join.map(&:compile!).join(' ')
      end

      def where_expression
        "WHERE #{where.map(&:compile!).join(' AND ')}" if where.any?
      end

      def group_expression
        "GROUP BY #{group.compile!}" if group
      end

      def having_expression
        "HAVING #{having.map(&:compile!).join(' AND ')}" if having.any?
      end

      def order_expression
        "ORDER BY #{order.compile!}" if order
      end

      def limit_expression
        "LIMIT #{limit.compile!}" if limit
      end

      def offset_expression
        "OFFSET #{offset.compile!}" if offset
      end
    end
  end
end
