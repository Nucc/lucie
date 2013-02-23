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

class ParameterPairing < Controller::Base
end