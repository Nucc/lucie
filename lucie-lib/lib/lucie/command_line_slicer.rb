class CommandLineSlicer
  def initialize(line)
    @line = line
  end

  def to_a
    neutral_chars = ["\\"]
    split_chars = [" "]
    string_chars = ["\"", "'"]

    neutral_status = false
    string_open = false

    parts = []
    read = ""
    @line.each_char do |c|
      if split_chars.include?(c)
        parts << read if read != ""
        read = ""
      else
        read += c
      end
    end
    parts << read if read != ""
    parts
  end
end