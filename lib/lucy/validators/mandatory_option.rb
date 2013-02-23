module Lucy
  module Validators
    module MandatoryOption

      class Validator
        def initialize(args)
          @argname = args.shift
        end

        def apply(params)
          fail RequestError unless params[:"#{@argname.gsub(/^-*/, '')}"]
        end
      end

      def mandatory(*args)
        v = Validator.new(args)
        v.apply(params)
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def mandatory(*args)
          self.validators << Validator.new(args)
        end
      end
    end
  end
end