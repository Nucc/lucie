class BeforeFilterController < Controller::Base
  before_filter :set_touched
  attr_reader :touched

  def set_touched
    @touched = true
  end

  def method1
  end
end

class BeforeFilterRecursionController < BeforeFilterController
  def method2
  end
end

class MultipleBeforeFilters < Controller::Base
  before_filter :set_one, :set_two

  def method3
  end

  attr_reader :one, :two

protected

  def set_one
    @one = true
  end

  def set_two
    @two = true
  end
end