# The MIT License (MIT)

# Copyright (c) 2014 Laszlo Papp, <laszlo.papp@bteam.hu>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

$LOAD_PATH << File.expand_path("..", __FILE__)

require "lucie/version"
require "lucie/exceptions"


# Lucie is a modular MVC terminal application framework. With Lucie easy to create
# command line application using controllers to describe the process, models to store
# additional data permanently, and views to generate configuration files for applications.
#
# Lucie-lib is a glue for these MVC components and provide additional helper methods to
# support faster and easier developing.
#
module Lucie

  include ::Lucie::Exceptions

  module Helpers
    autoload :ControllerName, "lucie/helpers/controller_name"
  end

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

require "lucie/command_line_parser"
require "lucie/app"
require "lucie/controller/base"

include Lucie
