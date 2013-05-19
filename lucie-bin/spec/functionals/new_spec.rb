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

    after_all do
      @tmp = File.expand_path("../../../tmp", __FILE__)
      system "cd #{Shellwords.escape(@tmp)} && rm -rf app_new"
    end

  end

private

  def tmp_dir
    File.expand_path("../../../tmp", __FILE__)
  end

  def app_dir
    File.join(tmp_dir, "app_new")
  end

end