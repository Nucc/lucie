module Lucie
  module Exceptions
    class RequestError < StandardError
      def initialize(validator)
        super "#{validator.description} (#{validator.short_option}) is mandatory parameter"
      end
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

    class ExitRequest < Exception
      attr_reader :exit
      def initialize(exit)
        @exit = exit
      end
    end
  end
end