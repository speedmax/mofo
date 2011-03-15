require 'rubygems'
require 'rake'
require File.join(File.dirname(__FILE__), "lib/mofo/version")

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "mofo"
    gemspec.summary = "mofo is a ruby microformat parser"
    gemspec.description = "mofo is a ruby microformat parser"
    gemspec.email = "jan@krutisch.de"
    gemspec.homepage = "http://github.com/halfbyte/mofo"
    gemspec.authors = ["Chris Wanstrath", "Jan Krutisch"]
    gemspec.version = Mofo::VERSION
    gemspec.test_files = Dir.glob('test/*_test.rb')
  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = Mofo::VERSION

  rdoc.main = "README" # page to start on
  rdoc.title = "mofo #{version}"

  rdoc.rdoc_dir = 'rdoc'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('CHAMGELOG*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
