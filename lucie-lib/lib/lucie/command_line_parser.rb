require "lucie/command_line_slicer"

module Lucie

  module Core

    # Command line parser extracts the controller name and action from the
    # application input and prepares the params hash for the controller.
    #
    class CommandLineParser

      attr_reader :options

      # Initializes a CommandLineParser
      #
      # @param parameters [String|Array] Input that needs to be processed
      #
      def initialize(parameters)
        @params_str = parameters.class == Array ? parameters.join(" ") : parameters
        @options = {}
        @options[:args] = []
        @latest_option = nil

        parse_options()
      end

      # Gets the value of an option
      #
      # For "--option value" the self[:option] returns "value"
      #
      # @param name [Symbol] Name of the option
      def [](name)
        @options[name]
      end

      # Shift the parameter list. Useful for removing the controller's name
      # from the beginning.
      #
      def shift
        @options[:args].shift
      end

      # Pairs short and long options.
      #
      # When -o is a shortened version of --option, then params[:o] must return
      # the same value as params[:option]. This method pairs these options.
      #
      # @param short [Symbol] Short version of the option
      # @param long  [Symbol] Long version of the option
      #
      def pair(short, long)
        short_p = remove_dashes(short).to_sym
        long_p = remove_dashes(long).to_sym

        if @options[short_p].class == String
          @options[long_p] = @options[short_p]
        else
          @options[short_p] = @options[long_p]
        end
      end

      # Is the option defined?
      #
      # @param option [Symbol] Name of the option
      def has_option?(option)
        @options[remove_dashes(option).to_sym] || false
      end

      # Get the values which has no options.
      #
      # Arguments are values without any option or tag. When the option
      # name is undefined, the value gets placed in args.
      #
      def args
        @options[:args].dup
      end

      # Checks whether the value is in the args.
      #
      # @param option [String] Name of the argument.
      #
      def has_arg?(option)
        @options[:args].include?(option)
      end

    private

      def parse_options
        array_of_options.each do |option|
          if is_option?(option)
            save_option(option)
          else
            save_parameter(option)
          end
        end
      end

      def is_option?(option)
        option =~ /^-/
      end

      def remove_dashes(option)
        option.gsub(/^-+/, "")
      end

      def save_option(option)
        without_dashes = remove_dashes(option)
        @options[without_dashes.to_sym] = true
        @latest_option = without_dashes.to_sym
      end

      def save_parameter(option)
        if @options[@latest_option].class == String
          @options[@latest_option] += [" ", option].join
        elsif !@latest_option
          @options[:args] ||= []
          @options[:args] << option
        else
          @options[@latest_option] = option
        end
      end

      def array_of_options
        Core::CommandLineSlicer.new(@params_str).to_a
      end
    end
  end
end