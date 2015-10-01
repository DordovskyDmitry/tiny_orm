module TinyORM
  module Association
    class HasMany < Base
      def initialize(owner, target, options = {})
        super
        @target
        @through = options[:through]
        @internal_key ||= :id
        @external_key ||= (@through ? :id : :"#{owner.to_s.downcase}_id")
      end

      def path
        return super unless @through
        through = @through.to_s.split('_').each{|s| s.extend(TinyORM::PluralSingularString) }.map(&:singularize).map(&:capitalize).join
        through_model = Object.const_get(through)

        owner_to_middle = @owner.associations[@through] || HasMany.new(@owner, @through, internal_key: @internal_key)
        internal_key = "#{@target.to_s.downcase}_id"
        target_to_middle = through_model.associations[@target.to_s.downcase.to_sym] || HasMany.new(through_model, nil, class_name:  @target, internal_key: internal_key, external_key: @external_key)
        [owner_to_middle, target_to_middle]
      end
    end
  end
end
