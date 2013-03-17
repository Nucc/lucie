module Lucie
  class Buffer

    attr_reader :output

    def initialize
      @output = String.new
    end

    def <<(str)
      @output += str.to_s
    end
  end
end