# -*- encoding: utf-8 -*-
require File.expand_path("../../lucie-lib/lib/lucie/version", __FILE__)
version = Lucie::VERSION

Gem::Specification.new do |s|
  s.name          = "lucie-bin"
  s.version       = version
  s.authors       = ["Nucc"]
  s.email         = ["nucc@bteam.hu"]
  s.description   = %q{Command line utility framework}
  s.summary       = %q{}
  s.homepage      = ""

  s.bindir      = 'bin'
  s.executables = ["lucie"]

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "lucie-lib", version
  s.add_dependency "lucie-cmd", version
  s.add_development_dependency "rake", "10.0.3"
  s.add_development_dependency "sdoc"
  s.add_development_dependency "minitest", "4.6"
end
