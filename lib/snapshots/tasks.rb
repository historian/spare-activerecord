
require 'fileutils'
  
desc "List all snapshot"
task :snapshots => :environment do
  Snapshots.find.each do |snapshot|
    snapshot =~ /snapshot_(\d+)\.rb$/
    timestamp = Time.at($1.to_i)
    puts "#{snapshot} @ #{timestamp}"
  end
end

namespace :snapshots do
  
  desc "Create a snapshot"
  task :dump => :environment do
    Snapshots.dump
  end
  
  desc "Load a snapshot. VERSION specifies the snapshot"
  task :load => :environment do
    if ENV['VERSION'].blank?
      puts "Please use VERSION to specify which snapshot you want to load."
      
    else
      Snapshots.load
    end
  end
  
end
