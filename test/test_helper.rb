require 'minitest/autorun'
require "mini_shoulda"

require File.expand_path('../../lib/lucy.rb', __FILE__)

class MiniTest::Spec
  include Lucy
end