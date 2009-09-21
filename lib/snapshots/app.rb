
module Snapshots
  class App < Thor
    
    class_option :app, :default => '.', :type => :string,
      :desc   => 'Path to the rails application',
      :banner => 'rails_root',
      :group  => 'Global'
    
    desc 'list', 'List all snapshots for a rails app.'
    def list
      goto_rails(self.options.app) do
        
        Snapshots.find.each do |snapshot|
          snapshot =~ /snapshot_(\d+)\.rb$/
          timestamp = Time.at($1.to_i)
          puts "#{$1} @ #{timestamp} : #{snapshot}"
        end
        
      end
    end
    
    desc 'dump', 'Make a new snapshot.'
    def dump
      goto_rails(self.options.app) do
        load_environment!
        
        begin
          Snapshots.dump
          puts "Snapshot was successfully created."
        rescue => e
          puts "An error occured while creating snapshot."
          puts "#{e.class}: #{e.message}"
          puts e.backtrace
        end
      end
    end
    
    desc 'load VERSION', 'Restore a snapshot.'
    def load(version)
      goto_rails(self.options.app) do
        load_environment!
        
        begin
          Snapshots.load(version)
          puts "Snapshot #{version} was successfully restored."
        rescue => e
          puts "An error occured while restoring snapshot #{version}."
          puts "#{e.class}: #{e.message}"
          puts e.backtrace
        end
      end
    end
    
    desc 'install', 'Install rake tasks in rails app.'
    def install
      goto_rails(self.options.app) do
        File.open('lib/tasks/snapshots.rake', 'w+') do |f|
          f.write <<-EOR
begin
  require 'rubygems'
  require 'snapshots/tasks'
rescue LoadError
  puts "Please install snapshots: [sudo] gem install snapshots"
end
EOR
        end
        puts "Rake tasks are successfully installed."
      end
    end
    
  private
    
    def load_environment!
      $rails_rake_task = true
      require(File.join(RAILS_ROOT, 'config', 'environment'))
    end
    
    def goto_rails(root_path, &proc)
      root_path = File.expand_path(root_path)
      
      unless File.directory?(root_path) and File.file?(File.join(root_path, 'config', 'environment.rb'))
        $stderr.puts "This is not a rails application!"
        exit(1)
      end
      
      Object.const_set('RAILS_ROOT', root_path)
      Dir.chdir(root_path, &proc)
    end
    
  end
end
