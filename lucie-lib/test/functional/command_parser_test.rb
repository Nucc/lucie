require "test_helper.rb"
require "stringio"
require "helpers/test_app"
require "fixtures/command_parser_fixtures"

class CommandProcessorTest < MiniTest::Spec

  should "parse commands" do
    assert_equal "Hello World", TestApp.run("command_parser hello").output
  end

  should "parse long parameter" do
    assert_equal "Parameter", TestApp.run("command_parser hello_2 --parameter Parameter").output
  end


  should "not give error when mandatory parameters are present" do
    assert_equal "Ok", TestApp.run("parameter_parser1 search -s").output
  end

  context "raise exception" do
    setup do
      TestApp.raise_exception = true
    end

    should "force mandatory parameters" do
      assert_raises(Lucie::RequestError){ TestApp.run("parameter_parser1 search") }
    end

    should "give error, when method has mandatory parameter but another shouldn't throw in this case" do
      assert_equal "Ok", TestApp.run("optional_mandatory search -s").output
      assert_raises(Lucie::RequestError){ TestApp.run("optional_mandatory search") }
      assert_equal "Ok", TestApp.run("optional_mandatory no_mandatory").output
    end
  end

  should "be able to pair parameters" do
    assert_equal "some_string", TestApp.run("parameter_pairing search_short -e some_string").output
    assert_equal "some_string", TestApp.run("parameter_pairing search_long --expression some_string").output
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

end