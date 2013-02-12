require_relative "../test_helper.rb"
require "helpers/test_app"
require "fixtures/command_parser_fixtures"

class CommandProcessorTest < MiniTest::Spec

  should "parse commands" do
    assert_equal "Hello World", TestApp.run("command_parser hello").output
  end

  should "parse long parameter" do
    assert_equal "Parameter", TestApp.run("command_parser hello_2 --parameter 'Parameter'").output
  end

end