module Lucie

  class Router

    def initialize(command, root)
      @command = CommandLineParser.new(command)
    end

    def task
      @task ||= @command.shift
    end

    def action
      @action ||= begin
        @command.args.first ? @command.args.first.to_sym : :index
      end
    end

    def controller
      @controller ||= controller_class.send(:new, command, self)
    end

    def controller_class
      if task
        @controller_class ||= [task.split("_").map{|i| i.capitalize}.join, "Controller"].join
        Object.const_get(@controller_class.to_sym)
      else
        include_controller_for "application"
        @controller_class = "ApplicationController"
        @action = :help
        Object.const_get(@controller_class.to_sym)
      end
    rescue NameError
      include_controller_for(task)
      Object.const_get(@controller_class.to_sym)
    end

    def include_controller_for(task)
      require File.join([root, "app/controllers", "#{task}_controller"])
    rescue LoadError
      raise ControllerNotFound, task
    end

    def call_action_on_controller
      method = action
      if controller_has_action? action
        # pop the args[0] element because this is the method
        @command.shift
        @action = action
      elsif controller_has_action? :no_method
        @action = :no_method
      else
        raise ActionNotFound.new(action, task)
      end
    end

    def controller_has_action?(action)
      @public_actions ||= begin
        controller_class.public_instance_methods - Controller::Base.public_instance_methods + [:help]
      end
      @public_actions.include?(action.to_sym)
    end

    def help?
      @command.has_option?("-h") || @command.has_option?("--help") || @command.has_arg?("help") || task == "help"
    end

  end
end