require_relative "../../lucie-lib/lib/lucie"
require 'minitest/autorun'
require 'minitest/spec'

class Minitest::Spec
  def setup
    App.init
  end
end

module Kernel

  def after_all &block
    MiniTest::Unit.after_tests do
      yield block
    end
  end

  def var sym
    self.class.instance_variable_get :"@#{sym}"
  end

end
