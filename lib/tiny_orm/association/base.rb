module TinyORM
  module Association
    class Base
      attr_reader :owner, :internal_key, :external_key

      def initialize(owner, target, options = {})
        @owner = owner
        @target = options[:class_name] || target.to_s.split('_').each{|s| s.extend(TinyORM::PluralSingularString) }.map(&:singularize).map(&:capitalize).join
        @internal_key = options[:internal_key]
        @external_key = options[:external_key]
      end

      def path
        [self]
      end

      def target
        Object.const_get(@target)
      end
    end
  end
end
