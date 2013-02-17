module Lucy
  module Validators
    module MandatoryOption

      class Validator
        def initialize(args)
        end

        def apply
          fail RequestError
        end
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