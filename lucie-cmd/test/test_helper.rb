if ENV["TRAVIS"]
  require 'coveralls'
  Coveralls.wear!
end

# MiniTest is integrated to Ruby library and by default the test wants to use that.
# Force the Rubygems version
require 'minitest/autorun'
require "mini_shoulda"
#require 'debugger'

require "lucie-cmd"

require "fixtures/command_fixture"

class MiniTest::Spec
end