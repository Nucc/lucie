require "test_helper"

class CommandLineParserTest < MiniTest::Spec

  include Core

  should "parse empty string" do
    parser = CommandLineParser.new ""
    hash = {:args => []}
    assert_equal hash, parser.options
  end

  should "parse short boolean value" do
    parser = CommandLineParser.new "-a"
    assert parser.options[:a]
  end

  should "parse more short boolean values" do
    parser = CommandLineParser.new "-a -b"
    assert parser.options[:a]
    assert parser.options[:b]
  end

  should "parse long boolean value" do
    parser = CommandLineParser.new "--long-parameter"
    assert parser.options[:"long-parameter"]
  end

  should "parse multiple long boolean values" do
    parser = CommandLineParser.new "--long-parameter --another-long-parameter"
    assert parser.options[:"long-parameter"]
    assert parser.options[:"another-long-parameter"]
  end

  should "parse string parameter" do
    parser = CommandLineParser.new "--string this_is_a_string"
    assert_equal "this_is_a_string", parser.options[:string]
  end

  should "parse more string parameters" do
    parser = CommandLineParser.new "--string this is a string"
    assert_equal "this is a string", parser.options[:string]
  end

  should "parse arguments" do
    parser = CommandLineParser.new "arg1 arg2 -x -y"
    assert_equal "arg1", parser.options[:args][0]
    assert parser.options[:x]
  end

  should "be able to shift the args array" do
    parser = CommandLineParser.new "arg1 arg2"
    arg = parser.shift
    assert_equal "arg1", arg
    assert_equal "arg2", parser.options[:args][0]
  end

  should "be able to answer the an argument is present or not" do
    parser = CommandLineParser.new "arg1 arg2"
    assert parser.has_arg?("arg1")
    assert parser.has_arg?("arg2")
    assert !parser.has_arg?("arg3")
  end

  should "be able to answer the parameter is present or not" do
    parser = CommandLineParser.new "arg1 -h -p"
    assert parser.has_option?("h")
    assert parser.has_option?("p")
    assert !parser.has_option?("print")
  end

  should "parse params enclosed with \" or ' as one arg" do
    parser = CommandLineParser.new "arg1 'arg2 arg3'"
    assert_equal "arg1", parser.args[0]
    assert_equal "arg2 arg3", parser.args[1]
  end

end