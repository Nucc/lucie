require "test_helper.rb"
require "helpers/test_app"
require "fixtures/command_parser_fixtures"

class CommandProcessorTest < MiniTest::Spec

  should "parse commands" do
    assert_equal "Hello World", TestApp.run("command_parser hello").output
  end

  should "parse long parameter" do
    assert_equal "Parameter", TestApp.run("command_parser hello_2 --parameter Parameter").output
  end

  should "force mandatory parameters" do
    assert_raises(Lucy::RequestError){ TestApp.run("parameter_parser1 search") }
  end

  should "not give error when mandatory parameters are present" do
    assert_equal "Ok", TestApp.run("parameter_parser1 search -s").output
  end

  should "give error, when method has mandatory parameter but another shouldn't throw in this case" do
    assert_equal "Ok", TestApp.run("optional_mandatory search -s").output
    assert_raises(Lucy::RequestError){ TestApp.run("optional_mandatory search") }
    assert_equal "Ok", TestApp.run("optional_mandatory no_mandatory").output
  end

end