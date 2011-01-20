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
        stream.puts \
        "  create_table \"schema_migrations\", :id => false, :force => true do |t|\n"+
        "    t.string \"version\"\n"+
        "  end\n"+
        "  add_index \"schema_migrations\", [\"version\"], :name => \"unique_schema_migrations\", :unique => true\n"
      end

      super(stream)
    end

  end
end
