require "bundler/gem_tasks"

SUBPROJECTS = %w(lucie-lib lucie-bin lucie-cmd)

desc 'Run all tests'
task :default => %w(test)
%w(doc test install).each do |task|
  desc "Run #{task} task for all projects"
  task task do
    errors = []
    SUBPROJECTS.each do |project|
      system(%(cd #{project} && #{$0} #{task})) || errors << project
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

task :release do
    errors = []
    SUBPROJECTS.dup.push(".").each do |project|
      system(%(cd #{project} && #{$0} release)) || errors << project
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
end