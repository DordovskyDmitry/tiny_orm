module TinyORM
  module Association
    class HasMany < Base
      def initialize(owner, target, options = {})
        super
        @through = options[:through]
        @internal_key ||= :id
        @external_key ||= (@through ? :id : :"#{owner.to_s.downcase}_id")
      end

      def path
        return super unless @through
        [owner_to_ligament, ligament_to_target]
      end

      private

      def owner_to_ligament
        @owner.associations[@through] || HasMany.new(@owner, @through, internal_key: @internal_key)
      end

      def ligament_to_target
        through_model = Object.const_get(camelize(@through))
        through_model.associations[@target.to_s.downcase.to_sym] ||
            HasMany.new(through_model, nil, class_name: @target, internal_key: "#{@target.to_s.downcase}_id", external_key: @external_key)
      end
    end
  end
end
