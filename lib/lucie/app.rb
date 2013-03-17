module Lucie
  class App
    def self.init(file = nil)
      File.expand_path("..", File.dirname(Kernel.caller.first))
    end

    def self.run(command)
      commands = command.split(" ")
      task = commands.shift
      controller = [task.split("_").map{|i| i.capitalize}.join, "Controller"].join

      klass = Object.const_get(controller.to_sym)
      @inst = klass.send(:new, commands)
      klass.apply_validators
      klass.pair_parameters
      @inst.send(commands.shift.to_sym)
      self
    end

    def self.output
      @inst.out.output
    end

    def self.config
    end

  end
end