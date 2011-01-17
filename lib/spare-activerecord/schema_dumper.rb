module Spare::ActiveRecord
  class SchemaDumper < AR::SchemaDumper

    def self.dump(options={})
      connection = options.delete(:connection) || AR::Base.connection
      dump_dir   = options.delete(:dump_dir)   || 'db/backup'
      FileUtils.mkdir_p(dump_dir)
      file = File.join(dump_dir, '_schema.rb')
      File.open(file, 'w+') { |file| super(connection, file) }
    end

    def tables(stream)
      if @connection.tables.include?('schema_migrations')
        table('schema_migrations', stream)
      end

      super(stream)
    end

  end
end
