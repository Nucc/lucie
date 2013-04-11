module Lucie
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

    def self.run(command = ARGV, root = nil)
      root = File.expand_path("..", File.dirname(Kernel.caller[0]))
      obj = self.new(command, root)
      obj.start
      obj.exit_value
    end

    def initialize(command, root)
      @root = File.expand_path("..", File.dirname(Kernel.caller[1]))
      @command = CommandLineParser.new(command)
      @exit_value ||= 0
      @task = nil
    end

    def start
      help? ? call_help : call_method_invoking_process
    end

    def exit_value
      @exit_value
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

    def help?
      @command.has_option?("-h") || @command.has_option?("--help") || @command.has_arg?("help") || task == "help"
    end

    def task
      @task ||= @command.shift
    end

    def action
      @action ||= @command.args.first
      @action ? @action.to_sym : :index
    end

    def controller
      @controller ||= controller_class.send(:new, command)
    end

    def controller_class
      if task
        @controller_class ||= [task.split("_").map{|i| i.capitalize}.join, "Controller"].join
        Object.const_get(@controller_class.to_sym)
      else
        @controller_class = "ApplicationController"
        @action = "help"
        Object.const_get(@controller_class.to_sym)
      end
    rescue NameError
      include_controller_for(task)
      Object.const_get(@controller_class.to_sym)
    end

    def include_controller_for(task)
      require [root, "app/controllers", "#{task}_controller"].join("/")
    rescue LoadError
      self.exit_value = 255
      raise ControllerNotFound, task
    end

    def call_action_on_controller
      method = action
      if controller.respond_to? method
        # pop the args[0] element because this is the method
        @command.shift
      else
        method = :no_method
      end
      self.exit_value = controller.send(method)
    rescue NameError
      self.exit_value = 255
      raise ActionNotFound.new(action, task)
    rescue Controller::ExitRequest => exit_request
      self.exit_value = exit_request.code
    end

    def apply_validators
      controller.class.apply_validators
    end

    def pair_parameters
      controller.class.pair_parameters
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