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

      def optional(*args)
        v = Validator.new(args)
        params.pair(v.short_option, v.long_option)
      end

      module ClassMethods
        def optional(*args)
          self.validators << Validator.new(args)
        end
      end
    end
  end
end