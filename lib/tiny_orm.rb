require "tiny_orm/version"
require 'tiny_orm/query/base'
require 'tiny_orm/query/where'

module TinyORM
  class Base
    def self.inherited(base)
      class << base
        attr_accessor :table_name
      end
    end

    def self.where(options = {})
      TinyORM::Query::Base.new(query_struct).where(options)
    end

    def self.query_struct
      {
          table_name: table_name,
          select: '',
          where: [],
          join: [],
          group: []
      }
    end
  end
end
