require "test_helper"
require "stringio"

class ShTest < MiniTest::Spec
  include Lucie::Commands

  it "runs a command" do
    sh "echo 123"
    assert_equal "123\n", output
  end

  it "runs more commands" do
    sh "echo 1"
    assert_equal "1\n", output
    sh "echo 2"
    assert_equal "2\n", output
  end

  it "knows the return status" do
    sh "false"
    assert_equal 1, status

    sh "true"
    assert_equal 0, status
  end

  it "can handle return status of concurrent processes" do
    i = 0
    th1 = Thread.new do
      sh "true"
      i = 1
      sleep 0 while i != 2
      assert 0, status
      i = 3
    end

    th2 = Thread.new do
      sleep 0 while i != 1
      sh "false"
      i = 2
      sleep 0 while i != 3
      assert 1, status
    end

    th1.join
    th2.join
  end

  it "should return true if response status of the command was 0" do
    assert_equal true, sh("true")
  end

  it "should return false if the response status of the command was not 0" do
    assert_equal false, sh("false")
  end

  it "should be able to put the output realtime" do
    set :live_output
    out, _ = capture_io do
      sh "echo test"
    end
    assert_equal "test\n", out
  end

  it "should be able to show the command" do
    set :show_command
    out, _ = capture_io do
      sh "echo test"
    end
    assert_equal "$ echo test\n", out
  end

  it "should have an unset to turn off realtime output" do
    set :live_output
    unset :live_output
    out, _ = capture_io do
      sh "echo test"
    end
    assert_equal "", out
  end

  it "should log stderr when live_output is on" do
    _, err = capture_io do
      set :live_output
      sh "echo test 1>&2"
    end
    assert_equal "test\n", err
  end

  it "should be able to use green color for output" do
    out, err = capture_io do
      green "Hello world"
      warn  "Hello world"
    end
    assert_equal "\e[32mHello world\e[0m\n", out
    assert_equal "\e[32mHello world\e[0m\n", err
  end

  it "should be able to use red color for output" do
    out, err = capture_io do
      red "Hello world"
      error "Hello world"
    end
    assert_equal "\e[31mHello world\e[0m\n", out
    assert_equal "\e[31mHello world\e[0m\n", err
  end

  it "should be able to use yellow color for output" do
    out, err = capture_io do
      yellow "Hello world"
      notice "Hello world"
    end
    assert_equal "\e[33mHello world\e[0m\n", out
    assert_equal "\e[33mHello world\e[0m\n", err
  end

end