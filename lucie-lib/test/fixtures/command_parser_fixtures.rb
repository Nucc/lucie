class CommandParserController < Controller::Base
  def hello
    out << "Hello World"
  end

  def hello_2
    out << params[:parameter]
  end
end

class ParameterParser1Controller < Controller::Base
  mandatory "-s", "Search expression"
  def search
    out << "Ok"
  end
end

class OptionalMandatoryController < Controller::Base
  def search
    mandatory "-s", "Search expression"
    out << "Ok"
  end

  def no_mandatory
    out << "Ok"
  end
end

class ParameterPairingController < Controller::Base
  optional "-e", "--expression", "Search expression"

  def search_short
    out << params[:expression]
  end

  def search_long
    out << params[:e]
  end
end