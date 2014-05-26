require "test_helper"
require "stringio"
require "fixtures/test_app"
require "fixtures/command_parser_fixtures"

describe App do

  should "parse commands" do
    assert_output("Hello World", nil) { TestApp.run("command_parser hello") }
  end

  should "parse long parameter" do
    assert_output("Parameter", nil) { TestApp.run("command_parser hello_2 --parameter Parameter") }
  end

  should "not give error when mandatory parameters are present" do
    assert_output("Ok", nil) { TestApp.run("parameter_parser1 search -s") }
  end

  context "raise exception" do
    setup do
      TestApp.raise_exception = true
    end

    should "force mandatory parameters" do
      assert_raises(Lucie::RequestError){ TestApp.run("parameter_parser1 search") }
    end

    should "give error, when method has mandatory parameter but another shouldn't throw in this case" do
      assert_output("Ok", nil) { TestApp.run("optional_mandatory search -s") }
      assert_raises(Lucie::RequestError){ TestApp.run("optional_mandatory search") }
      assert_output("Ok", nil) { TestApp.run("optional_mandatory no_mandatory") }
    end

    should "not be able to call method from Object class" do
      assert_raises(Lucie::ActionNotFound) { TestApp.run("derived public_methods") }
    end

    should "not be able to call method from Controller::Base class" do
      assert_raises(Lucie::ActionNotFound) { TestApp.run("derived params") }
    end
  end

  should "be able to pair optional parameters" do
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional search_short -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional search_long  -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional search_short --expression some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional search_long --expression some_string") }
  end

  should "be able to pair mandatory parameters" do
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory search_short -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory search_long  -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory search_short --expression some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory search_long --expression some_string") }
  end

  should "be able to pair nested mandatory parameters" do
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory_nested nested_short -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory_nested nested_long -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory_nested nested_short --expression some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_mandatory_nested nested_long --expression some_string") }
  end

  should "be able to pair nested optional parameters" do
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional_nested nested_short -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional_nested nested_long -e some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional_nested nested_short --expression some_string") }
    assert_output("some_string", nil) { TestApp.run("parameter_pairing_optional_nested nested_long --expression some_string") }
  end

  should "write to stderr that no controller found when controller is missing" do
    assert_output "", "Controller is not found for no_controller." do
      TestApp.run("no_controller")
    end
  end

  should "write to stderr that no action found when action is missing" do
    assert_output "", "no_action is not found in optional_mandatory." do
      TestApp.run("optional_mandatory no_action")
    end
  end

  should "write user friendly message when mandatory parmaeter is missing" do
    assert_output "", "Search expression (-s) is mandatory parameter" do
      TestApp.run "parameter_parser1 search"
    end
  end

  should "write help message for help command" do
    assert_output "Help", "" do
      TestApp.run "parameter_parser1 help"
    end
  end

  should "call help method of ApplicationController when controller name is missing" do
    assert_output "ApplicationController::help", "" do
      TestApp.run "", File.expand_path("../../test_app/", __FILE__)
    end
  end

  should "return the exit value" do
    assert_equal 1, TestApp.run("exit_value method1")
  end

  should "return 0 if exit value is missing" do
    assert_equal 0, TestApp.run("exit_value no_exit")
  end

  should "return 255 when controller or action is missing" do
    assert_equal 255, TestApp.run("no_controller_with_this_name")
  end

  should "call index method when only the task present" do
    assert_output "index_method", "" do
      TestApp.run("call_index")
    end
  end

  should "call method_missing if task method is missing and leave the task in args" do
    assert_output "no_method_with_this_name", "" do
      TestApp.run("method_missing no_method_with_this_name")
    end
  end

  should "remove the task from the params[:args] when method is found" do
    assert_output "arg1", "" do
      TestApp.run("method_should_be_removed call_this_method arg1 arg2")
    end
  end

  should "have a root directory which is the directory contains the bin and app folders" do
    assert_equal File.expand_path("../..", __FILE__), TestApp.init("", nil).root
  end

  should "know the directory where it was called" do
    assert_equal TestApp.new("", nil).pwd.path, File.expand_path("../../../", __FILE__).path
  end

  should "store the ENV" do
    assert_equal ENV["PWD"], TestApp.init([], "").env["PWD"]
  end

  should "find other controllers as well in controllers directory without require statement" do
    if defined?(FakeController)
      Object.send(:remove_const, :FakeController)
    end

    assert_output "ok", "" do
      TestApp.run "inheritance index", File.expand_path("../../test_app/", __FILE__)
    end
  end
end