class CommandParserController < Controller::Base
  def hello
    print "Hello World"
  end

  def hello_2
    print params[:parameter]
  end
end

class ParameterParser1Controller < Controller::Base
  mandatory "-s", "Search expression"
  def search
    print "Ok"
  end
end

class OptionalMandatoryController < Controller::Base
  def search
    mandatory "-s", "Search expression"
    print "Ok"
  end

  def no_mandatory
    print "Ok"
  end
end

class ParameterPairingMandatoryController < Controller::Base
  mandatory "-e", "--expression", "Search expression"

  def search_short
    print params[:e]
  end

  def search_long
    print params[:expression]
  end
end

class ParameterPairingMandatoryNestedController < Controller::Base
  def nested_short
    mandatory "-e", "--expression", "Search expression"
    print params[:e]
  end

  def nested_long
    mandatory "-e", "--expression", "Search expression"
    print params[:expression]
  end
end

class ParameterPairingOptionalController < Controller::Base
  optional "-e", "--expression", "Search expression"

  def search_short
    print params[:e]
  end

  def search_long
    print params[:expression]
  end
end

class ParameterPairingOptionalNestedController < Controller::Base
  def nested_short
    optional "-e", "--expression", "Search expression"
    print params[:e]
  end

  def nested_long
    optional "-e", "--expression", "Search expression"
    print params[:expression]
  end
end

class ExitValueController < Controller::Base
  def method1
    exit 1
  end

  def no_exit
    "asdf"
  end
end

class CallIndexController < Controller::Base
  def index
    print "index_method"
  end
end

class MethodMissingController < Controller::Base
  def index
    print params[:args][0]
  end

  alias_method :no_method, :index
end

class DerivedController < CallIndexController
  def new_method
    print "new_method"
  end
end

class MethodShouldBeRemovedController < Controller::Base
  def call_this_method
    print params[:args][0]
  end
end

