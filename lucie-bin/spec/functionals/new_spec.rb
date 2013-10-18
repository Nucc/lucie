require 'spec_helper'
require 'new_controller'
require 'shellwords'

describe NewController do

  describe :index do
    @before_all ||= begin
      @tmp = File.expand_path("../../../tmp", __FILE__)
      @bin = File.expand_path("../../../bin/lucie", __FILE__)
      system "cd #{Shellwords.escape(@tmp)} && #{Shellwords.escape(@bin)} new app_new"
    end

    it "should create a new project" do
      assert File.directory?(app_dir)
    end

    it "should generate runnable file" do
      assert File.executable?(File.join(app_dir, "bin/app_new"))
    end

    it "should generate application controller file" do
      exists?("app/controllers/application_controller.rb")
    end

    it "should generate a Gemfile" do
      exists?("Gemfile")
    end

    it "should include the lucie-lib in the Gemfile" do
      found = false
      File.open(app_path("Gemfile")) do |f|
        f.each_line do |line|
          found ||= (line =~ /lucie/)
        end
      end
      assert found
    end

    after_all do
      @tmp = File.expand_path("../../../tmp", __FILE__)
      system "cd #{Shellwords.escape(@tmp)} && rm -rf app_new"
    end

  end

private

  def exists?(relative_path)
    File.exists?(app_path(relative_path))
  end

  def app_path(relative_path)
    File.join(app_dir, relative_path)
  end

  def tmp_dir
    File.expand_path("../../../tmp", __FILE__)
  end

  def app_dir
    File.join(tmp_dir, "app_new")
  end

end