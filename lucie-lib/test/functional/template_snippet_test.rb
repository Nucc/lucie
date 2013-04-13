require "test_helper"
require "fixtures/template_snippet_fixtures"
require "tempfile"

class TemplateSnippetTest < MiniTest::Spec

  include Snippets::Template

  before do
    @tmp_filename = template_path
    remove_file(@tmp_filename) # if it exists
  end

  after do
    remove_file(@tmp_filename)
    FileUtils.rmtree([template_dir, "a"].join("/"))
  end

  describe "create_file" do

    should "be able to create an empty file" do
      create_file @tmp_filename
      assert File.exists?(@tmp_filename)
    end

    should "be able to generate multi level directory if it doesn't exist" do
      @tmp_filename = [template_dir, "a", "b", template_file_name].join("/")
      create_file @tmp_filename
      assert File.exists?(@tmp_filename)
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

    should "generate file relative to PWD that comes from app.pwd" do
      app = Class.new do
        attr_reader :root

        def initialize(root)
          @root = root
        end
      end

      TemplateController.new("", app.new(template_dir)).test_1(template_file_name)
      assert_equal "test_1", File.read(template_path)
    end
  end

  context "template" do
    before do @template_file = Tempfile.new(template_file_name, template_dir); end

    should "generate file from template using absolute directory" do
      File.open(@template_file, "w+") do |f|
        f.write "template <%= @variable %>"
      end
      @variable = "test_var_for_template"

      template @template_file, @tmp_filename
      assert_equal "template test_var_for_template", File.open(@tmp_filename, "r").read
    end

  end

  private

  def template_dir
    File.expand_path("../../../tmp", __FILE__)
  end

  def template_file_name
    @template_file_name ||= begin
      rand = (Time.now.to_i * rand(10**6)).to_i
      "template_#{rand}"
    end
  end

  def template_path
    @template_path ||= begin
      [template_dir, template_file_name].join("/")
    end
  end

  def remove_file(filename)
    @filename ||= begin
      FileUtils.remove_file(filename) if File.exists?(filename)
    end
  end

end