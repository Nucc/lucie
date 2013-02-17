module Lucy
  module Controller
    class Base

      class << self
        @validators = []
      end

      def initialize(params)
      end

      def out
        @buffer ||= Buffer.new
        @buffer
      end

      def params
        {:parameter => "Parameter"}
      end

      def self.validators
        @validators ||= []
        @validators
      end

      def self.apply_validators
        validators.each {|validator| validator.apply } if validators
      end

      include Validators::MandatoryOption

    end
  end
end