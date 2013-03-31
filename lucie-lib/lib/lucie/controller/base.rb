module Lucie
  module Controller
    class Base

      include Validators::MandatoryOption
      include Validators::Optional

      class << self
        @validators = []
        @params = CommandLineParser.new("")
      end

      def initialize(command_line_parser)
        self.class.params = command_line_parser
      end

      def self.params=(params)
        @params = params
      end

      def params
        self.class.params
      end

      def self.params
        @params
      end

      def self.validators
        @validators ||= []
        @validators
      end

      def self.pair_parameters
        validators.each do |validator|
          short = validator.short_option
          long  = validator.long_option

          if short != "" && long != ""
            params.pair(short, long)
          end
        end
      end

      def self.apply_validators
        validators.each {|validator| validator.apply(params) } if validators
      end

      def exit(value)
        raise ExitRequest, value
      end

      def help
        "Help"
      end

    end
  end
end