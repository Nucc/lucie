require_relative "lucie/version"
require_relative "lucie/exceptions"

module Lucie

  module Controller
    autoload :ExitRequest, "lucie/controller/exit_request"
  end

  module Validators
    autoload :MandatoryOption, "lucie/validators/mandatory_option"
    autoload :Optional, "lucie/validators/optional"
    autoload :Base, "lucie/validators/base"
  end

  module Snippets
    autoload :Template, "lucie/snippets/template"
  end

end

require_relative "lucie/command_line_parser"
require_relative "lucie/app"
require_relative "lucie/controller/base"

include Lucie

