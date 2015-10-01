module TinyORM
  module Association
    class Base
      attr_reader :owner, :target, :internal_key, :external_key

      def initialize(owner, target, options = {})
        @owner = owner
        @target = options[:class]
        @internal_key = options[:internal_key]
        @external_key = options[:external_key]
      end

      def path
        [self]
      end
    end
  end
end
