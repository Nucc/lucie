module Lucie
  #
  # Validators are useful to verify input data. Example for validator:
  #
  #   class Controller
  #     optional "-h", "--help", "This is the help"
  #   end
  #
  module Validators
    class Base
      def initialize(*args)
        @argname = args.flatten
      end

      def apply(params)
        fail NotImplemented
      end

      def short_option
        @argname.select{|option| option[0] == "-" && option[1] != "-"}.join.strip
      end

      def long_option
        @argname.select{|option| option[0] == "-" && option[1] == "-"}.join.strip
      end

      def description
        @argname.select{|option| option[0] != "-" }.first
      end
    end
  end
end