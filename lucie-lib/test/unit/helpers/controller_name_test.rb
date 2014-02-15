require "test_helper"

class ControllerNameTest < MiniTest::Unit::TestCase

  include Helpers

  def test_controller_name_capitalizer
    assert_equal "Test", ControllerName.new("test").capitalized
    assert_equal "TestController", ControllerName.new("test_controller").capitalized
    assert_equal "", ControllerName.new("").capitalized
  end

  def test_controller_name_name
    assert_equal "test_controller", ControllerName.new("test_controller").name
  end
end