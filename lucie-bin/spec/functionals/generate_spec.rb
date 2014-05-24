require 'spec_helper'
require 'generate_controller'
require 'shellwords'

describe GenerateController do

  @before_all ||= begin
    @tmp = File.expand_path("../../../tmp", __FILE__)
    system "cd #{Shellwords.escape(@tmp)} && rm -rf generator_new"
    @bin = File.expand_path("../../../bin/lucie", __FILE__)
    system "cd #{Shellwords.escape(@tmp)} && #{Shellwords.escape(@bin)} new generator_new"
  end

  before do
    @app_path = File.expand_path("../../../tmp/generator_new", __FILE__)
    @lucie_path = File.expand_path("../../../bin/lucie", __FILE__)
  end

  describe "controller" do

    it "should create a new controller file" do
      generate("controller_name1")
      assert File.exist?(controller_path("controller_name1"))
    end

    it "should create a new controller file with controller class in it" do
      generate("controller_name2")
      content = ""
      File.open(controller_path("controller_name2")) do |file|
        content = file.read
      end
      expected = "class ControllerName2Controller < ApplicationController\nend"

      assert_equal expected, content
    end

    it "should throw error when the file exists" do
      generate("controller3")
      assert_output nil, "File #{controller_path('controller3')} already exists\n" do
        generate "controller3"
      end
    end

    def generate(name)
      cmd = ["cd #{Shellwords.escape(@app_path)} && #{Shellwords.escape(@lucie_path)} generate controller #{name}"]
      stdout, stderr, status = Open3.capture3(*cmd)
      $stderr.print stderr
      $stdout.print stdout
    end

    def controller_path(name)
      File.join(@app_path, "app", "controllers", "#{name}_controller.rb")
    end

  end
end