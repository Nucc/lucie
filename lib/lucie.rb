require "lucie/version"
require "lucie/exceptions"

module Lucie
  module Controller
    autoload :Base, "controller/base"
  end

  module Validators
    autoload :MandatoryOption, "validators/mandatory_option"
    autoload :Optional, "validators/optional"
    autoload :Base, "validators/base"
  end

  module Snippets
    autoload :Template, "snippets/template"
  end

  autoload :App, "app"
  autoload :Buffer, "buffer"
  autoload :CommandLineParser, "command_line_parser"
end

include Lucie

APP_ROOT ||= File.expand_path("../..", __FILE__)