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
        @owner.associations(@through) || begin
          reverse_assoc = through_class_name.associations(assoc_name(@owner))
          internal_key = (reverse_assoc && reverse_assoc.external_key) || @internal_key
          external_key = (reverse_assoc && reverse_assoc.internal_key)
          HasMany.new(@owner, @through, internal_key: internal_key, external_key: external_key)
        end
      end

      def ligament_to_target
        through_class_name.associations(assoc_name(@target)) || begin
          reverse_assoc = target.associations(@through)
          internal_key = (reverse_assoc && reverse_assoc.external_key) || :"#{assoc_name(@target)}_id"
          external_key = (reverse_assoc && reverse_assoc.internal_key) || @external_key
          HasMany.new(through_class_name, nil, class_name: @target, internal_key: internal_key, external_key: external_key)
        end
      end

      def through_class_name
        @_through_class_name ||= to_class_name(@through).constantize
      end

      def assoc_name(name)
        name.to_s.underscore.to_sym
      end
    end
  end
end
