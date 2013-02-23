module Lucy
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
    end
  end
end