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

  it "should log the cd path on console when live_output is on" do
    out, _ = capture_io do
      set :live_output
      cd "/tmp"
    end
    assert_equal "$ cd '/tmp'\n", out
  end
end