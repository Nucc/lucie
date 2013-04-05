# -*- encoding: utf-8 -*-
version = File.read(File.expand_path('../version', __FILE__)).strip
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "lucie"
  gem.version       = version
  gem.authors       = ["Nucc"]
  gem.email         = ["nucc@bteam.hu"]
  gem.description   = %q{Command line utility framework}
  gem.summary       = %q{}
  gem.homepage      = "http://my.luc.ie"

  gem.files = ["README.md"]

  gem.add_dependency "lucie-lib", version
  gem.add_dependency "lucie-bin", version
end
