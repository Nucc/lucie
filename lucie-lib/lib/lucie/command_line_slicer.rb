module Lucie

  module Core
    # Command Line Slicer can split the input string to words.
    #
    class CommandLineSlicer

      # Initializes a CommandLineSlicer object with the input.
      #
      # @param line [String] The input that need to be sliced
      def initialize(line)
        @line = line.split("")
        @parts = []
        @neutral_status = false
        @quotation_open = false
        @scanned = ""
      end

      # Returns the words of the input in an array.
      #
      def to_a
        each_char do |char|
          if boundary? char
            save_chunk
          elsif in_quoatation? char
            toggle_quotation_state
          elsif neutral? char
            neutral :on
          else
            neutral :off
            append char
          end
        end
        save_chunk
      end

    private

      def append(char)
        @scanned += char
      end

      def each_char(&blk)
        while @line.size > 0
          yield(@line.shift)
        end
      end

      def toggle_quotation_state
        @quotation_open = !@quotation_open
      end

      def save_chunk
        @parts << @scanned if @scanned != ""
        @scanned = ""
        @parts
      end

      def neutral(sym)
        @neutral_status = (sym == :on)
      end

    private

      def neutral_chars
        ["\\"]
      end

      def boundary_chars
        [" "]
      end

      def quotation_chars
        ["\"", "'"]
      end

      def boundary?(char)
        boundary_chars.include?(char) && !@neutral_status && !@quotation_open
      end

      def in_quoatation?(char)
        quotation_chars.include?(char) && !@neutral_status
      end

      def neutral?(char)
        neutral_chars.include?(char) && !@neutral_status
      end
    end
  end
end