module Lucie

  #
  # Lucie::App represents the application context. When a lucie application starts,
  # it requires information about its environment, like root path, env, command. App
  # also responsible for loading the right controller and to execute the process how the
  # input will be parsed and the business logic is executed.
  #
  class App

    class << self
      #
      # Let the exception leave the application when any occur.
      #
      # Normally the application doesn't raise any exception, just stops quietly.
      # When the application is under debugging, developer needs more, detailed description
      # about the problem. Suggested to turn this attribute on during developing.
      #
      #  App.raise_exception = true
      #
      attr_accessor :raise_exception

      # Sets the log level of the application.
      #
      attr_accessor :log_level

      #
      # Root directory of the source of application.
      #
      # Template and other source paths are calculated relatively to this directory.
      #
      attr_accessor :root

      @raise_exception = false
      @log_level = :info
    end

    # Command line input that is being executed. Usually it equals with ARGV.
    #
    attr_reader :command

    # Root of the application. Same as App.root, it's a reference for that.
    #
    attr_reader :root

    # The directory where from the application has been executed.
    #
    attr_reader :pwd

    # Initializes and starts the applicaiton. Shortcut for self.init && self.start
    #
    def self.run(command = ARGV, root = nil, pwd = nil)
      root ||= File.expand_path("..", File.dirname(Kernel.caller[0]))
      instance = self.init(command, root, pwd)
      self.start(instance)
    end

    # Initializes the application.
    #
    # @param command [Array or String]
    # @param root [String] Path of the root of the app. [default: current application's path]
    # @param pwd [String] Path of the terminal position.
    #
    def self.init(command = ARGV, root = nil, pwd = nil)
      root ||= File.expand_path("..", File.dirname(Kernel.caller[0]))
      self.new(command, root, pwd)
    end

    # Starts the application instance and returns its exit status.
    #
    # @param instance [App] Application instance
    #
    def self.start(instance)
      instance.start
      instance.exit_value
    end

    def initialize(command, root, pwd = nil)
      @root = root
      @command = Core::CommandLineParser.new(command)
      @exit_value ||= 0
      @task = nil
      @pwd = pwd || ENV["PWD"]
      Dir.chdir(@pwd)
    end

    # Starts the application.
    def start
      help? ? call_help : call_method_invoking_process
    end

    # Exit status of the application
    def exit_value
      @exit_value
    end

    # Environment of the application. Contains the ENV of the terminal.
    def env
      ENV
    end

private

    def call_method_invoking_process
      autoload_controllers
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
      @action ||= begin
        @command.args.first ? @command.args.first.to_sym : :index
      end
    end

    def controller
      @controller ||= controller_class.send(:new, command, self)
    end

    def controller_class
      controller_class = begin
        if task
          [task.split("_").map{|i| i.capitalize}.join, "Controller"].join
        else
          @action = :help
          "ApplicationController"
        end
      end

      begin
        Object.const_get(controller_class.to_sym)
      rescue NameError
        self.exit_value = 255
        raise ControllerNotFound.new task
      end
    end

    def autoload_controllers
      base_path = File.join([root, "app/controllers"])
      $LOAD_PATH << base_path
      Dir.glob(File.join([base_path, "*_controller.rb"])).each do |path|
        filename = File.basename(path)
        controller_name = filename.split(".rb").first
        if controller_name.to_s.length > 0
          const_name = Helpers::ControllerName.new(controller_name).capitalized

          # place the constant to the root namespace
          Object.class_eval do
            autoload const_name.to_sym, controller_name
          end
        end
      end
    end

    def call_action_on_controller
      begin
        self.exit_value = controller.send(:apply_action, action, command)
      rescue ActionNotFound
        self.exit_value = controller.send(:apply_action, :no_method)
      end
    rescue ActionNotFound
      raise ActionNotFound.new(action, task)
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
