class NewController < Controller::Base

  include Snippets::Template

  def index
    @project_name = params.shift
    @lucie_version = Lucie::VERSION

    template("new/bin/bin.tt", "#{@project_name}/bin/#{@project_name}")
    template("new/app/application_controller.rb.tt", "#{@project_name}/app/controllers/application_controller.rb")
    template("new/Gemfile.tt", "#{@project_name}/Gemfile")

    File.chmod(0755, "#{app.pwd}/#{@project_name}/bin/#{@project_name}")
  end

  def no_method
    index
  end
end
