require 'open4'

module Lucie
  module Commands

  protected

    def sh(*args)
      @commands_helper ||= CommandsHelper.new
      @commands_helper.sh(*args)
    end

    def cd(*args)
      @commands_helper ||= CommandsHelper.new
      @commands_helper.pwd = File.join(args)
    end

    def output
      @commands_helper.output
    end

    def status
      @commands_helper.status
    end

  private

    class CommandsHelper
      attr_accessor :pwd

      def initialize
        @stderr = $stderr
        @pwd = Dir.pwd
      end

      def sh(*args)
        command = args.join(" ")
        @pid, @stdin, @stdout, @stderr = Open4::popen4("cd \"#{pwd}\" && #{command}")
        @ignored, @status = Process::waitpid2 @pid
      end

      def output
        @stdout.read
      end

      def status
        @status.to_i % 255
      end

      def pwd=(val)
        @pwd = File.expand_path(val, @pwd)
      end
    end
  end
end