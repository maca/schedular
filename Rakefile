require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "schedular"
    gem.summary     = %Q{Bare Bones Events CMS Rails Engine}
    gem.description = %Q{Bare Bones Events CMS Rails Engine, event dates can be inputed as text in spanish, english date recognition is next.}
    gem.email       = "macarui@gmail.com"
    gem.homepage    = "http://github.com/maca/schedular"
    gem.authors     = ["Macario Ortega"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency 'table_builder', '>= 0.2.3'
    gem.add_dependency 'eventual',      '>= 0.5.6'
    gem.add_dependency 'es-mx-locale',  '>= 0.1.1'
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "schedular #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
