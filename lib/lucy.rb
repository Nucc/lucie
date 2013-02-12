require "lucy/version"

module Lucy
  module Controller
    autoload :Base, "controller/base"
  end

  autoload :App, "app"
  autoload :Buffer, "buffer"
  autoload :CommandLineParser, "command_line_parser"
end
