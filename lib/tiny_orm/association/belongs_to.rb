module TinyORM
  module Association
    class BelongsTo < Base
      def initialize(owner, target, options = {})
        super
        @internal_key ||= :"#{target}_id"
        @external_key ||= :id
      end
    end
  end
end
