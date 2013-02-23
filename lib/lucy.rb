require "lucy/version"
require "lucy/exceptions"

module Lucy
  module Controller
    autoload :Base, "controller/base"
  end

  module Validators
    autoload :MandatoryOption, "validators/mandatory_option"
  end

  autoload :App, "app"
  autoload :Buffer, "buffer"
  autoload :CommandLineParser, "command_line_parser"
end

include Lucy