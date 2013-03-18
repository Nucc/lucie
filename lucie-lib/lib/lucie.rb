require "lucie/version"
require "lucie/exceptions"

module Lucie
  module Controller
    autoload :Base, "lucie/controller/base"
  end

  module Validators
    autoload :MandatoryOption, "lucie/validators/mandatory_option"
    autoload :Optional, "lucie/validators/optional"
    autoload :Base, "lucie/validators/base"
  end

  module Snippets
    autoload :Template, "lucie/snippets/template"
  end

  autoload :App, "lucie/app"
  autoload :Buffer, "lucie/buffer"
  autoload :CommandLineParser, "lucie/command_line_parser"
end

include Lucie

