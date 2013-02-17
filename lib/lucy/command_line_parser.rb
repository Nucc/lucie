class CommandLineParser

  attr_reader :options

  def initialize(plain_parameter_string)
    @params_str = plain_parameter_string.to_s
    @options = {}
    @latest_option = nil

    parse_options()
  end

private

  def parse_options
    array_of_options.each do |option|
      if is_option?(option)
        save_option(option)
      else
        save_parameter(option)
      end
    end
  end

  def is_option?(option)
    option =~ /^-/
  end

  def remove_dashes(option)
    option.gsub!(/^-+/, "")
  end

  def save_option(option)
    remove_dashes(option)
    @options[option.to_sym] = true
    @latest_option = option.to_sym
  end

  def save_parameter(option)
    if @options[@latest_option].class == String
      @options[@latest_option] += [" ", option].join
    elsif !@latest_option
      @options[:args] ||= []
      @options[:args] << option
    else
      @options[@latest_option] = option
    end
  end

  def array_of_options
    @params_str.strip.split
  end
end