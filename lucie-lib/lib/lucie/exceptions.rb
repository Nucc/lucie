module Lucie
  class RequestError < StandardError
  end

  class ControllerNotFound < StandardError
    def initialize(controller_name)
      super "Controller is not found for #{controller_name}."
    end
  end

  class ActionNotFound < StandardError
    def initialize(action, controller)
      super "#{action} is not found in #{controller}."
    end
  end

end