require 'tiny_orm/version'
Dir[File.dirname(__FILE__) + '/tiny_orm/**/*.rb'].each { |file| require file }

module TinyORM
  class Base
    def self.inherited(base)
      class << base
        attr_accessor :table_name
      end
      base.send(:include, TinyORM::Association)
    end

    def self.method_missing(name, *args)
      query_obj = TinyORM::Query::Base.new(query_struct)
      query_obj.respond_to?(name) ? query_obj.send(name, *args) : super
    end

    def self.respond_to_missing?(name, include_private = false)
      TinyORM::Query::Base.new(query_struct).respond_to?(name) || super
    end

    def self.query_struct
      TinyORM::Query::Container.new(self)
    end
    private_class_method :query_struct
  end
end
