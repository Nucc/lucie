class CommandFixture

  include Lucie::Commands

  def initialize
    @r, @io = IO.pipe
    @commands_helper = CommandsHelper.new @io
  end

  def output
    out = []
    @io.close
    @r.each_line{|line| out << line.chomp}
    out.join("\n")
  end

  def test_sh *args
    sh *args
  end
end