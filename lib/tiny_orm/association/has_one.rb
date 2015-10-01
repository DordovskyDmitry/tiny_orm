module TinyORM
  module Association
    class HasOne < Base
      def initialize(owner, target, options = {})
        super
        @target ||= Object.const_get(target.to_s.capitalize)
        @internal_key ||= :id
        @external_key ||= :"#{owner.to_s.downcase}_id"
      end
    end
  end
end
