module Lucie
  module Controller
    class ExitRequest < Exception
      attr_reader :code
      def initialize(code)
        @code = code
      end
    end
  end
end