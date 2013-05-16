require_relative "../../lucie-lib/lib/lucie"
require 'minitest/autorun'
require 'minitest/spec'

class Minitest::Spec
  def setup
    App.init
  end
end