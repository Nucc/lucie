module Lucie
  module Commands

  protected

    def sh(*args)
      @commands_helper ||= CommandsHelper.new
      @commands_helper.sh *args
    end

  private

    class CommandsHelper
      def initialize(stdout = $stdout, stderr = $stderr)
        @stdout = stdout
        @stderr = stderr
      end

      def sh(*args)
        system *args, out: @stdout, err: @stderr
      end
    end
  end
end