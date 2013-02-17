require "test_helper"

class CommandLineParserTest < MiniTest::Spec

  should "parse empty string" do
    parser = CommandLineParser.new ""
    assert_equal Hash.new, parser.options
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

end