module TinyORM
  module Query
    class Container
      attr_reader :table_name
      attr_accessor :select, :where, :join, :order, :limit, :offset, :group, :having

      def initialize(table_name)
        @table_name = table_name
        @where = []
        @join = []
        @having = []
      end

      def compile!
        #TODO compile parts and join them to valid query
      end
    end
  end
end
