
$:.unshift(File.expand_path(File.dirname(__FILE__))) unless $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'thor'

module Snapshots
  autoload :DatabaseDumper, 'snapshots/database_dumper'
  autoload :DatabaseLoader, 'snapshots/database_loader'
  autoload :App,            'snapshots/app'
  
  class << self
    
    def find(path="db/snapshots/snapshot_*.rb")
      Dir.glob(path)
    end
    
    def load(version_or_path)
      unless String === version_or_path
        raise ArgumentError, "argument must be a String"
      end
      
      path = if version_or_path =~ /\.rb$/
        version_or_path
      else
        "db/snapshots/snapshot_#{version_or_path}.rb"
      end
      
      unless File.exists?(path)
        raise LoadError, "missing snapshot: #{path}"
      end
      
      Kernel.load(path)
    end
    
    def dump(snapshot_path="db/snapshots/snapshot_#{Time.now.to_i}.rb", connection=ActiveRecord::Base.connection)
      FileUtils.mkdir_p(File.dirname(snapshot_path))
      File.open(snapshot_path, 'w+') do |f|
        Snapshots::DatabaseDumper.dump(connection, f)
      end
    end
    
  end
end
