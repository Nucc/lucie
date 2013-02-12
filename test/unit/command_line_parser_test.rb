require "test_helper"

class CommandLineParserTest < MiniTest::Spec

  should "parse empty string" do
    parser = CommandLineParser.new ""
    assert_equal Hash.new, parser.result
  end

  should "parse short boolean value" do
    parser = CommandLineParser.new "-a"
    assert parser.result[:a]
  end

  should "parse more short boolean values" do
    parser = CommandLineParser.new "-a -b"
    assert parser.result[:a]
    assert parser.result[:b]
  end

  should "parse long boolean value" do
    parser = CommandLineParser.new "--long-parameter"
    assert parser.result[:"long-parameter"]
  end

  should "parse multiple long boolean values" do
    parser = CommandLineParser.new "--long-parameter --another-long-parameter"
    assert parser.result[:"long-parameter"]
    assert parser.result[:"another-long-parameter"]
  end

end