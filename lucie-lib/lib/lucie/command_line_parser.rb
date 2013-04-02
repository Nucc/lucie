require "lucie/command_line_slicer"

class CommandLineParser

  attr_reader :options

  def initialize(parameters)
    @params_str = parameters.class == Array ? parameters.join(" ") : parameters
    @options = {}
    @latest_option = nil

    parse_options()
  end

  def [](name)
    @options[name]
  end

  def shift
    @options[:args].shift
  end

  def pair(short, long)
    short_p = remove_dashes(short).to_sym
    long_p = remove_dashes(long).to_sym

    if @options[short_p].class == String
      @options[long_p] = @options[short_p]
    else
      @options[short_p] = @options[long_p]
    end
  end

  def has_option?(option)
    @options[remove_dashes(option).to_sym] || false
  end

  def has_arg?(option)
    @options[:args].include?(option)
  end

  def args
    @options[:args].dup
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
    option.gsub(/^-+/, "")
  end

  def save_option(option)
    without_dashes = remove_dashes(option)
    @options[without_dashes.to_sym] = true
    @latest_option = without_dashes.to_sym
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
    CommandLineSlicer.new(@params_str).to_a
  end
end