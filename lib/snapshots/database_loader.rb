
module Snapshots
  class DatabaseLoader
    
    def self.load(connection=ActiveRecord::Base.connection, &proc)
      new(connection).load(&proc)
    end
    
    def initialize(connection)
      @connection = connection
    end
    
    def load(&proc)
      instance_eval(&proc)
    end
    
    def for_table(name, &proc)
      Snapshots::TableLoader.load(@connection, name, &proc)
    end
    
  end
  
  class TableLoader
    
    def self.load(connection, table, &proc)
      new(connection, table).load(&proc)
    end
    
    def initialize(connection, table)
      @table  = table
      @connection = connection
      @columns = @connection.columns(table)
    end
    
    def load
      @connection.execute("DELETE FROM #{@table}")
      yield(self)
    end
    
    def insert(attributes={})
      quoted_attributes = attributes_with_quotes(attributes)
      
      return if quoted_attributes.empty?
      
      column_names = @columns.collect { |column| "#{@table}.#{column.name}" }
      statement = "INSERT INTO #{@table} (#{column_names.join(', ')}) VALUES(#{quoted_attributes.join(', ')})"
      
      @connection.insert(statement, "#{@table} Create")
    end
    
    def attributes_with_quotes(attributes={})
      quoted = []
      @columns.each do |column|
        value = attributes[column.name.to_sym]
        quoted.push @connection.quote(value, column)
      end
      quoted
    end
    
  end
end
