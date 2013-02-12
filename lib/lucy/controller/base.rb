module Lucy
  module Controller
    class Base

      def initialize(params)
      end

      def out
        @buffer ||= Buffer.new
        @buffer
      end

      def params
        {:parameter => "Parameter"}
      end
    end
  end
end