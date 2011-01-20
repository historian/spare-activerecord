# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spare-activerecord/version"

Gem::Specification.new do |s|
  s.name        = "spare-activerecord"
  s.version     = Spare::ActiveRecord::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "https://githib.com/fd/spare-activerecord"
  s.summary     = %q{Backups for ActiveRecord}
  s.description = %q{Spare based backups for ActiveRecord}

  s.rubyforge_project = "spare-activerecord"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'spare'
end
