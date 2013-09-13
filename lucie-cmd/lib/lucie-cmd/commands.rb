require 'open4'

module Lucie
  module Commands

  protected

    def sh(*args)
      @commands_helper ||= CommandsHelper.new
      @commands_helper.sh *args
    end

    def output
      @commands_helper.output
    end

    def status
      @commands_helper.status
    end

  private

    class CommandsHelper
      def initialize
        @stderr = $stderr
      end

      def sh(*args)
        @pid, @stdin, @stdout, @stderr = Open4::popen4(args.join(" "))
        @ignored, @status = Process::waitpid2 @pid
      end

      def output
        @stdout.read
      end

      def status
        @status.to_i % 255
      end
    end
  end
end