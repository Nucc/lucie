require 'open3'

module Lucie

  # Lucie provides library to work with command line applications in an
  # easy way.
  #
  # In order to use these methods in your controller class you need to include
  # it to the class.
  #
  #   class SampleController < Lucie::Controller::Base
  #     include Lucie::Commands
  #   end
  #
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

    def set(opts = [])
      @commands_helper ||= CommandsHelper.new
      @commands_helper.set(Array(opts))
    end

    def unset(opts = [])
      @commands_helper ||= CommandsHelper.new
      @commands_helper.unset(Array(opts))
    end

    def error(text)
      stderr colorize(text, 31)
    end

    def warn(text)
      stderr colorize(text, 32)
    end

    def notice(text)
      stderr colorize(text, 33)
    end

    def red(text)
      stdout colorize(text, 31)
    end

    def green(text)
      stdout colorize(text, 32)
    end

    def yellow(text)
      stdout colorize(text, 33)
    end

    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def stderr(text)
      $stderr.puts text
    end

    def stdout(text)
      $stdout.puts  text
    end

  private

    class CommandsHelper
      attr_reader :pwd

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

        @output = ""

        Open3.popen3("cd \"#{pwd}\" && #{command}") {|stdin, stdout, stderr, wait_thr|
          @pid = wait_thr.pid # pid of the started process.

          if @opts.include? :live_output
            puts stdout.read if !stdout.eof
            @stderr << stderr.read if !stderr.eof
          end
          @output << stdout.read if !stdout.eof
          @output << stderr.read if !stderr.eof

          @status = wait_thr.value # Process::Status object returned.
        }
      end

      def output
        @output
      end

      def status
        @status.exitstatus.to_i % 255
      end

      def pwd=(val)
        @pwd = File.expand_path(val, @pwd)
        if @opts.include? :live_output
          puts "$ cd '#{@pwd}'"
        end
      end

      def set(opts = [])
        @opts = @opts | opts
      end

      def unset(opts = [])
        opts.each { |opt| @opts.delete(opt) }
      end
    end
  end
end