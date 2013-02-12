class CommandLineParser
  def initialize(plain_parameter_string)
    @params_str = plain_parameter_string.to_s
    @result = {}
    start_parser
  end

  def start_parser
    pieces = @params_str.strip.split
    pieces.each do |piece|
      piece.gsub!(/^-+/, "")
      @result[piece.to_sym] = true
    end
  end

  def result
    @result
  end
end