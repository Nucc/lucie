require "test_helper"
require "stringio"

class CommandTest < MiniTest::Spec
  context "sh" do
    before do
      @fixture = CommandFixture.new
    end

    it "should be able to run a command" do
      @fixture.test_sh "echo 123"
      assert_equal "123", @fixture.output
    end
  end
end