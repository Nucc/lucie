# -*- encoding: utf-8 -*-
version = File.read(File.expand_path('../../version', __FILE__)).strip
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lucie/version'

Gem::Specification.new do |gem|
  gem.name          = "lucie"
  gem.version       = version
  gem.authors       = ["Nucc"]
  gem.email         = ["nucc@bteam.hu"]
  gem.description   = %q{Command line utility framework}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mini_shoulda"
end
