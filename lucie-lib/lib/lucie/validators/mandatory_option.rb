module Lucie
  module Validators
    #
    # Mandatory option is able to force out an option or input for the application.
    #
    module MandatoryOption

      class Validator < Base
        def apply(params)
          fail RequestError.new(self) unless params[:"#{short_option.gsub(/^-*/, '')}"]
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