require 'open4'

module Lucie
  module Commands

  protected

    def sh(*args)
      @commands_helper ||= CommandsHelper.new
      status = @commands_helper.sh(*args)
      status.to_i == 0
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

    def on(opts = [])
      @commands_helper ||= CommandsHelper.new
      @commands_helper.on(Array(opts))
    end

  private

    class CommandsHelper
      attr_accessor :pwd

      def initialize
        @stderr = $stderr
        @pwd = Dir.pwd
        @opts = []
      end

      def sh(*args)
        command = args.join(" ")

        if @opts.include? :show_command
          puts "$ #{command}"
        end

        @status = Open4::popen4("cd \"#{pwd}\" && #{command}") do |pid, stdin, stdout, stderr|
          @stdin, @stderr, @pid = stdin, stderr, pid
          @output = ""
          if !stdout.eof()
            new_content = stdout.read
            if @opts.include? :live_input
              print new_content
            end
            @output << new_content
          end
        end
      end

      def output
        @output
      end

      def status
        @status.exitstatus.to_i % 255
      end

      def pwd=(val)
        @pwd = File.expand_path(val, @pwd)
      end

      def on(opts = [])
        @opts = @opts | opts
      end
    end
  end
end