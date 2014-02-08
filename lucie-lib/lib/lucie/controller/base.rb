module Lucie
  module Controller
    class Base

      include Validators::MandatoryOption
      include Validators::Optional

      attr_reader :app

      class << self
        @validators = []
        @params = Core::CommandLineParser.new("")
      protected
        @before_filter_args = []
        attr_accessor :before_filter_args
      end

      def help
        "Help"
      end

      def initialize(command_line_parser, app)
        self.class.params = command_line_parser
        @app = app
      end

    protected

      def params
        self.class.params
      end

      def self.params=(params)
        @params = params
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

      def self.before_filter(*args)
        self.before_filter_args ||= []
        args.each do |value|
          self.before_filter_args << value
        end
      end

      def exit(value)
        raise ExitRequest, value
      end

      def apply_action(action, command = nil)
        if has_action? action
          # pop the action name from the params[:args] list
          command.shift unless command.nil?
          self.apply_before_filters
          return self.send(action)
        else
          raise ActionNotFound.new(action, nil)
        end
      rescue Controller::ExitRequest => exit_request
        return exit_request.code
      end

      def apply_before_filters
        klass = self.class
        while klass.respond_to?(:before_filter)
          args = Array(klass.send(:before_filter_args))
          args.each do |method|
            self.send(method.to_sym)
          end
          klass = klass.superclass
        end
      end

      def has_action?(action)
        @public_actions ||= begin
          self.class.public_instance_methods - Object.public_instance_methods
        end
        @public_actions.include?(action.to_sym)
      end
    end
  end
end