require "test_helper"

class ControllerBaseTest < MiniTest::Unit::TestCase

  include Controller

  def test_app_can_be_set
    app = Object.new
    controller = Base.new(nil, app)
    assert_equal app, controller.app
  end

  def test_before_filter
    require "before_filter_controller"

    controller = BeforeFilterController.new(nil, Object.new)
    controller.send(:apply_action, :method1)
    assert_equal true, controller.touched
  end

end