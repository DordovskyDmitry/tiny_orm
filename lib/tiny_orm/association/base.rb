module TinyORM
  module Association
    class Base
      attr_reader :owner, :internal_key, :external_key

      def initialize(owner, target, options = {})
        @owner = owner
        @target = options[:class_name] || to_class_name(target)
        @internal_key = options[:internal_key]
        @external_key = options[:external_key]
      end

      def path
        [self]
      end

      def target
        @target.constantize
      end

      private

      def to_class_name(str)
        str.to_s.camelize.singularize
      end
    end
  end
end
