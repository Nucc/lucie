# MiniTest is integrated to Ruby library and by default the test wants to use that.
# Force the Rubygems version
require 'minitest/autorun'
require "mini_shoulda"
require 'debugger'

require File.expand_path('../../lib/lucie.rb', __FILE__)

LUCIE_ROOT = File.expand_path File.dirname(__FILE__)

class MiniTest::Spec
  include Lucie

  def setup
    redirect_stderr
  end

  def teardown
    reset_stderr_redirection
  end

  def redirect_stderr
    @stderr = $stderr
    $stderr = StringIO.new
  end

  def reset_stderr_redirection
    $stderr = @stderr
  end
end