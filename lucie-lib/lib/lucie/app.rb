module Lucie
  class App

    attr_reader :command
    attr_reader :root

    def self.run(command = ARGV, root = nil)
      obj = self.new(command, root)
      obj.start
      obj
    end

    def initialize(command, root)
      self.root = root || File.expand_path("..", File.dirname(Kernel.caller[2]))
      self.command = command
    end

    def start
      help? ? call_help : call_method_invoking_process
    end

    def output
      controller.out.output
    end

    class << self
      attr_accessor :raise_exception
      attr_accessor :log_level
      raise_exception = false
      log_level = :info
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

    def command=(value)
      @command ||= value
      @command = @command.split(" ") if @command.is_a? String
    end

    def help?
      @command.select{ |command| command == "-h" || command == "--help" || command == "help"}.length > 0 ||
      task == "help"
    end

    def task
      @task ||= @command.shift
    end

    def action
      @action ||= @command.shift.to_sym
    end

    def controller
      @controller ||= controller_class.send(:new, command)
    end

    def controller_class
      @controller_class ||= [task.split("_").map{|i| i.capitalize}.join, "Controller"].join
      Object.const_get(@controller_class.to_sym)
    rescue NameError
      include_controller_for(task)
      Object.const_get(@controller_class.to_sym)
    end

    def include_controller_for(task)
      require [root, "app/controllers", "#{task}_controller"].join("/")
    rescue LoadError => e
      raise ControllerNotFound, task
    end

    def call_action_on_controller
      controller.send(action)
    rescue NameError
      raise ActionNotFound.new(action, task)
    end

    def apply_validators
      controller.class.apply_validators
    end

    def pair_parameters
      controller.class.pair_parameters
    end

    def root=(value)
      @root = value
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

  end
end