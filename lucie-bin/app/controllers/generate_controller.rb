class GenerateController < Controller::Base

  include Snippets::Template
  include Lucie::Commands

  def controller
    @controller = Lucie::Helpers::ControllerName.new(params[:args].shift)
    target = File.join(app.pwd, "app", "controllers", "#{@controller.name}_controller.rb")
    if File.exist?(target)
      stderr "File #{target} already exists"
    else
      template("generate/controller.tt", target)
    end
  end

end
