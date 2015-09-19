module TinyORM
  module Query
    class Base
      def initialize(query = nil)
        @query = query || {
            select: '',
            where: [],
            join: '',
            group: ''
        }
      end

      def where(options = {})
        (self.class == Where) ? self.and(options) : Where.new(@query).and(options)
      end
    end
  end
end
