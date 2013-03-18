module Lucie
  class App

    attr_reader :command

    def self.run(command = ARGV, root = nil)
      self.new(command, root)
    end

    def initialize(command, root)
      self.root = root || File.expand_path("..", File.dirname(Kernel.caller[2]))
      self.command = command

      controller.class.apply_validators
      controller.class.pair_parameters
      controller.send(action)
      self
    end

    def root
      @root
    end

    def output
      controller.out.output
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
      require [root, "app/controllers", "#{task}_controller"].join("/")
      Object.const_get(@controller_class.to_sym)
    end

    def root=(value)
      @root = value
    end

  end
end