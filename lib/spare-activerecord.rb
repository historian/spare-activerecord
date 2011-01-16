module Spare
  module ActiveRecord

    require 'spare'
    require 'activerecord'

    AR = ::ActiveRecord

    require 'spare-activerecord/version'
    require 'spare-activerecord/database_dumper'
    require 'spare-activerecord/content_dumper'
    require 'spare-activerecord/schema_dumper'

  end
end
