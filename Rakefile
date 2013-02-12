require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/lucy'
  t.libs << 'test'
  t.test_files = FileList['test/*/*_test.rb']
  t.verbose = false
end
task :default => :test