# -*- encoding: utf-8 -*-
require File.expand_path("../lucie-lib/lib/lucie/version", __FILE__)
version = Lucie::VERSION
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "lucie"
  gem.version       = version
  gem.authors       = ["Nucc"]
  gem.email         = ["nucc@bteam.hu"]
  gem.description   = %q{Command line utility framework}
  gem.summary       = %q{Lucie is a console application framework like Rails for Ruby programmers or Symfony for PHP developers. While these tools help the web developers in create beautiful websites rapidly, there's no easy way to create complex console applications like do this in Ruby on Rails. Lucie wants to bridge this gap.}
  gem.homepage      = "http://my.luc.ie"

  gem.files = ["README.md"]

  gem.add_dependency "lucie-lib", version
  gem.add_dependency "lucie-bin", version
end
