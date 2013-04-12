require "test_helper"

class ControllerBaseTest < MiniTest::Unit::TestCase

  include Controller

  def test_app_can_be_set
    app = Object.new
    controller = Base.new(nil, app)
    assert_equal app, controller.app
  end

end