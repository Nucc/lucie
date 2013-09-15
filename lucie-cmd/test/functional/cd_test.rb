require "test_helper"
require "stringio"

class CdTest < MiniTest::Spec
  include Lucie::Commands

  it "changes directory" do
    cd "/bin"
    sh "pwd"
    assert_equal "/bin\n", output
  end

  it "changes directory multiple times" do
    cd "/sbin"
    cd "/bin"
    sh "pwd"
    assert_equal "/bin\n", output
  end

  it "knows relative paths" do
    cd "/bin"
    cd "../sbin"
    sh "pwd"
    assert_equal "/sbin\n", output
  end
end