# MiniTest is integrated to Ruby library and by default the test wants to use that.
# Force the Rubygems version
require 'minitest/autorun'
require "mini_shoulda"

require File.expand_path('../../lib/lucie.rb', __FILE__)

LUCIE_ROOT = File.expand_path File.dirname(__FILE__)
App.init()

class MiniTest::Spec
  include Lucie
end