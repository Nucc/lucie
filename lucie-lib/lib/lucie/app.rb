module Lucie
  class App

    attr_reader :command

    def self.run(command = ARGV, root = nil)
      self.new(command, root)
    end

    def initialize(command, root)
      self.root = root || File.expand_path("..", File.dirname(Kernel.caller[2]))
      self.command = command

      apply_validators
      pair_parameters
      call_action_on_controller

      self
    rescue => e
      self.exception = e
      give_information_about_exception
      write_exception_to_stderr
    end

    def root
      @root
    end

    def output
      controller.out.output
    end

    class << self
      attr_accessor :raise_exception
      raise_exception = false
    end

private

    def command=(value)
      @command ||= value
      @command = @command.split(" ") if @command.is_a? String
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

    def give_information_about_exception
      $stderr << @exception.to_s.strip
    end

    def write_exception_to_stderr
      raise @exception if @exception && self.class.raise_exception
    end

  end
end