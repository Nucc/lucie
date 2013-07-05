

module Lucie
  # App responsible for configuring and launch the application
  # based on Lucie application framework.
  #
  class App

    class << self
      attr_accessor :raise_exception
      attr_accessor :log_level
      attr_accessor :root
      @raise_exception = false
      @log_level = :info
    end

    attr_reader :command
    attr_reader :root
    attr_reader :pwd

    def self.run(command = ARGV, root = nil)
      root ||= File.expand_path("..", File.dirname(Kernel.caller[0]))
      instance = self.init(command, root)
      self.start(instance)
    end

    def self.init(command = ARGV, root = nil)
      root ||= File.expand_path("..", File.dirname(Kernel.caller[0]))
      self.new(command, root)
    end

    def self.start(instance)
      instance.start
      instance.exit_value
    end

    def initialize(command, root)
      @root = root

      @router = Router.new(command, root)

      @command = CommandLineParser.new(command)
      @exit_value ||= 0
      @task = nil
      @pwd = ENV["PWD"]
    end

    def start
      @router.help? ? call_help : call_method_invoking_process
    end

    def exit_value
      @exit_value
    end

    def env
      ENV
    end

private

    def call_method_invoking_process
      apply_validators
      pair_parameters
      call_action_on_controller
    rescue => e
      self.exception = e
      give_user_friendly_error_message
      write_backtrace
      raise if self.class.raise_exception
    end

    def apply_validators
      @router.controller.class.apply_validators
    end

    def pair_parameters
      @router.controller.class.pair_parameters
    end

    def exception=(exception)
      @exception = exception
    end

    def give_user_friendly_error_message
      $stderr << @exception.to_s.strip
    end

    def write_backtrace
      $stderr.puts Kernel.caller.join("\n") if App.log_level == :debug
    end

    def call_help
      $stdout << controller.help
    end

    def exit_value=(exit_value)
      @exit_value = exit_value if exit_value.is_a?(Fixnum)
    end
  end
end
