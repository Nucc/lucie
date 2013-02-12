module Lucy
  class App
    def self.run(command)
      commands = command.split(" ")
      task = commands.shift
      controller = [task.split("_").map{|i| i.capitalize}.join, "Controller"].join

      @inst = Object.const_get(controller.to_sym).send(:new, commands)
      @inst.send(commands.shift.to_sym)
      self
    end

    def self.output
      @inst.out.output
    end
  end
end