module Spare
  module ActiveRecord

    require 'spare'
    require 'active_record'

    AR = ::ActiveRecord

    require 'spare-activerecord/version'
    require 'spare-activerecord/task'
    require 'spare-activerecord/database_dumper'
    require 'spare-activerecord/content_dumper'
    require 'spare-activerecord/schema_dumper'
    require 'spare-activerecord/database_loader'
    require 'spare-activerecord/content_loader'
    require 'spare-activerecord/schema_loader'

  end
end
