module Lucie
  module Validators
    module Optional

      class Validator < Base
        def apply(params)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def optional(*args)
          self.validators << Validator.new(args)
        end
      end
    end
  end
end