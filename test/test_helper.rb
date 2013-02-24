# MiniTest is integrated to Ruby library and by default the test wants to use that.
# Force the Rubygems version
require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require "mini_shoulda"

require File.expand_path('../../lib/lucy.rb', __FILE__)

class MiniTest::Spec
  include Lucy
end