module Spare::ActiveRecord
  class SchemaLoader

    def self.load(options={})
      new(options).load
    end

    def initialize(options={})
      @connection = options.delete(:connection) || AR::Base.connection
      @dump_dir   = options.delete(:dump_dir)   || 'db/backup'
    end

    def load
      _stdout, $stdout = $stdout, StringIO.new
      Kernel.load File.join(@dump_dir, '_schema.rb')
    ensure
      $stdout = _stdout
    end

  end
end
