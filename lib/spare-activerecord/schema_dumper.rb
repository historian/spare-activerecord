module Spare::ActiveRecord
  class SchemaDumper < AR::SchemaDumper

    def self.dump(options={})
      dump_dir = options.delete(:dump_dir) || 'db/backup'
      file = File.join(dump_dir, 'schema.rb')
      File.open(file, 'w+') { |file| super(file) }
    end

  end
end
