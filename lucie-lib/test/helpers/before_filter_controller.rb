class BeforeFilterController < Controller::Base

  before_filter :set_touched

  attr_reader :touched

  def set_touched
    @touched = true
  end

  def method1
  end

end