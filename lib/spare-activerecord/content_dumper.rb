module Spare::ActiveRecord
  class ContentDumper

    def self.dump(options={})
      new(options).dump
    end

    def initialize(options={})
      @connection     = options.delete(:connection)     || AR::Base.connection
      @dump_dir       = options.delete(:dump_dir)       || 'db/backup'
      @partition_size = options.delete(:partition_size) || 250
    end

    def dump_all_tables
      @connection.tables.sort.each do |tbl|
        dump_table(tbl)
      end
    end

    def dump_table(table)
      count = count_records_in_table(table)
      partition_count = (count / @partition_size.to_f).ceil

      # nothing to export
      return if partition_count == 0

      FileUtils.mkdir_p(File.join(@dump_dir, table))

      partition_count.times do |partition|
        dump_table_partition(table, partition)
      end
    end

    def count_records_in_table(table)
      table = @connection.quote_table_name(table)
      count = @connection.select_value("SELECT COUNT(*) FROM #{table}")
      count = count.to_i
    end

    def dump_table_partition(table, partition)
      table = @connection.quote_table_name(table)
      rows  = @connection.select_all("SELECT * FROM #{table} LIMIT #{@partition_size} OFFSET #{@partition_size * partition}")

      partition_name = "%05d.yml" % [partition + 1]
      File.open(File.join(@dump_dir, table, partition_name), "w+") do |file|
        rows.each do |row|
          YAML.dump(row, file)
        end
      end
    end

  end
end
