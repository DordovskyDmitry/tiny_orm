require 'tiny_orm/version'
require 'tiny_orm/query/get/get'
require 'tiny_orm/query/get/condition'
Dir[File.dirname(__FILE__) + '/tiny_orm/**/**/*.rb'].each { |file| require file }

module TinyORM
  class Base
    def self.inherited(base)
      class << base
        attr_accessor :table_name
      end
      base.send(:include, TinyORM::Association)
    end

    def initialize(options)
      @attributes = options
      assign(options)
    end

    def self.create(options)
      self.new(options).save
      self
    end

    def assign(options)
      options.each { |k, v| self.send("#{k}=", v) }
      self
    end

    def update(options)
      assign(options).save
    end

    def save
      if new_record?
        self.class.insert(@attributes)
      else
        self.class.update({id: self.id}, @attributes)
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
