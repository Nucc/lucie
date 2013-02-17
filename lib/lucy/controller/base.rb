require 'pp'

module Lucy
  module Controller
    class Base

      class << self
        @validators = []
        @params = CommandLineParser.new("")
      end

      def initialize(params)
        self.class.params = CommandLineParser.new(params)
      end

      def out
        @buffer ||= Buffer.new
        @buffer
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

      def self.apply_validators
        validators.each {|validator| validator.apply(params) } if validators
      end

      include Validators::MandatoryOption

    end
  end
end