module Lucie
  module Helpers
    #
    # Converts controller name from underscore form to capitalized
    #
    class ControllerName
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def capitalized
        @name.split("_").map{|x| x.capitalize}.join
      end
    end
  end
end