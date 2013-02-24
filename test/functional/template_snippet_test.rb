require "test_helper"

class TemplateSnippetTest < MiniTest::Spec

  include Snippets::Template

  before do
    @tmp_filename = template_path
    remove_file(@tmp_filename) # if it exists
  end

  after do remove_file(@tmp_filename); end


  describe "create_file" do

    should "be able to create an empty file" do
      create_file @tmp_filename
      assert File.exists?(@tmp_filename)
    end

    should "be able to generate multi level directory if it doesn't exist" do
      @tmp_filename = [template_dir, "a", "b", template_file_name].join("/")
      create_file @tmp_filename
      assert File.exists?(@tmp_filename)
      FileUtils.rmtree([template_dir, "a"].join("/"))
    end

    should "be able to add content to a file using block" do
      create_file @tmp_filename do |f|
        f.puts "line_1"
        f.puts "line_2"
      end

      lines = File.new(@tmp_filename, "r").read.split("\n")
      assert_equal "line_1", lines[0]
      assert_equal "line_2", lines[1]
    end

    should "be able to append content to a file" do
      create_file @tmp_filename do |f| f.puts "line_1"; end
      create_file @tmp_filename do |f| f.puts "line_2"; end

      lines = File.new(@tmp_filename, "r").read.split("\n")
      assert_equal "line_1", lines[0]
      assert_equal "line_2", lines[1]
    end
  end

  context "template" do
    before do @template_file = template_path; end
    after  do remove_file(@template_file) end

    should "generate file from template"
  end

  private

  def template_dir
    File.expand_path("../../../tmp", __FILE__)
  end

  def template_file_name
    rand = (Time.now.to_i * rand(10**6)).to_i
    "template_#{rand}"
  end

  def template_path
    [template_dir, template_file_name].join("/")
  end

  def remove_file(filename)
    FileUtils.remove_file(filename) if File.exists?(filename)
  end

end