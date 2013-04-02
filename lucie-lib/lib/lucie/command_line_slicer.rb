class CommandLineSlicer
  def initialize(line)
    @line = line
  end

  def to_a
    # need refactor

    neutral_chars = ["\\"]
    split_chars = [" "]
    quotation_chars = ["\"", "'"]

    neutral_status = false
    quotation_open = false

    parts = []
    read = ""
    @line.each_char do |c|
      if split_chars.include?(c) && !neutral_status && !quotation_open
        parts << read if read != ""
        read = ""
      elsif quotation_chars.include?(c) && !neutral_status
        quotation_open = !quotation_open
      else
        neutral_status = false
        if neutral_chars.include?(c)
          neutral_status = true
          next
        end
        read += c
      end
    end
    parts << read if read != ""
    parts
  end
end