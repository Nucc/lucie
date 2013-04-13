class TemplateController < Controller::Base

  include Snippets::Template

  def test_1(filename)
    create_file filename do |f| f.print "test_1"; end
  end

end