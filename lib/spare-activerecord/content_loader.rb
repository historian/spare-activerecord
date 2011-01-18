module Spare::ActiveRecord
  class ContentLoader

    def self.load(options={})
      new(options).load
    end

    def initialize(options={})
      @connection = options.delete(:connection) || AR::Base.connection
      @dump_dir   = options.delete(:dump_dir)   || 'db/backup'
    end

    def load
      load_all_tables
    end

    def load_all_tables
      Dir.glob(File.join(@dump_dir, '*')).each do |table|
        next unless File.directory?(table)
        table_name = File.basename(table)
        # puts "Loading table #{table_name}"
        load_table(table_name)
      end
    end

    def load_table(table_name)
      columns = @connection.columns(table_name, "#{table_name} Columns")

      key_list = columns.map { |c| @connection.quote_column_name(c.name) }
      key_list = key_list.join(', ')

      qtable_name = @connection.quote_table_name(table_name)

      @connection.execute("DELETE FROM #{qtable_name}", "Clear")

      Dir.glob(File.join(@dump_dir, table_name, '*.yml')).each do |partition|
        load_partition(qtable_name, partition, columns, key_list)
      end
    end

    def load_partition(table_name, partition, columns, key_list)
      # puts "-- Loading partition #{File.basename(partition)}"
      File.open(partition, 'r') do |file|
        YAML.each_document(file) do |row|

          value_list = columns.map { |c| @connection.quote(row[c.name], c).gsub('[^\]\\n', "\n").gsub('[^\]\\r', "\r") }
          value_list = value_list.join(', ')

          @connection.execute "INSERT INTO #{table_name} (#{key_list}) VALUES (#{value_list})", 'Backup Insert'

        end
      end
    end

  end
end
