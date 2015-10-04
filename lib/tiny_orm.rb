require 'tiny_orm/version'
require 'tiny_orm/query/get/get'
require 'tiny_orm/query/get/condition'
Dir[File.dirname(__FILE__) + '/tiny_orm/**/**/*.rb'].each { |file| require file }

module TinyORM
  class Base
    def self.inherited(base)
      class << base
        attr_writer :table_name
      end
      base.send(:include, TinyORM::Association)
    end

    def self.table_name
      @table_name ||=  begin
                         model_name = self.to_s.scan(/[A-Z]+[a-z]*/).map(&:downcase).join('_')
                         model_name.extend(TinyORM::PluralSingularString)
                         model_name.pluralize
      end
    end

    def self.respond_to_missing?(name, include_private = false)
      TinyORM::Query::Base.new(self).respond_to?(name) || super
    end

    def self.method_missing(name, *args)
      query_obj = TinyORM::Query::Base.new(self)
      query_obj.respond_to?(name) ? query_obj.send(name, *args) : super
    end
  end
end
