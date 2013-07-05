# -*- encoding: utf-8 -*-
version = File.read(File.expand_path('../../version', __FILE__)).strip

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
#  s.add_development_dependency "sdoc"
#  s.add_development_dependency "minitest"
end
