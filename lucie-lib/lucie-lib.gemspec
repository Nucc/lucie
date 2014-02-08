# -*- encoding: utf-8 -*-
require File.expand_path("../../lucie-lib/lib/lucie/version", __FILE__)
version = Lucie::VERSION
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = "lucie-lib"
  s.version       = version
  s.authors       = ["Nucc"]
  s.email         = ["nucc@bteam.hu"]
  s.description   = %q{Command line utility framework}
  s.summary       = %q{Library part of Lucie framework. Use only this gem, if you don't need project generator.}
  s.homepage      = "http://my.luc.ie"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "rake", "10.0.3"
  s.add_development_dependency "minitest", "4.6"
  s.add_development_dependency "mini_shoulda", "0.4.0"
  s.add_development_dependency "sdoc"
  s.add_development_dependency "m", "~> 1.3.1"
end
