module TinyORM
  module Association
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def associations(name = nil)
        name ? @associations[name] : @associations
      end

      %w(has_many has_one belongs_to).each do |method|
        define_method method do |target, options = {}|
          #TODO association.define_methods
          @associations ||= {}
          @associations[target] = "TinyORM::Association::#{method.camelize}".constantize.new(self, target, options)
        end
      end
    end
  end
end
