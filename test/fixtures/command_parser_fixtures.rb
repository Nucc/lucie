class CommandParserController < Lucy::Controller::Base
  def hello
    out << "Hello World"
  end

  def hello_2
    out << params[:parameter]
  end

end