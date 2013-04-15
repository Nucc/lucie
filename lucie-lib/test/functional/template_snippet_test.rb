require "test_helper"
require "fixtures/template_snippet_fixtures"
require "tempfile"

class TemplateSnippetTest < MiniTest::Spec

  include Snippets::Template

  before do
    @template_path = nil
    @template_file_name = nil
    @tmp_filename = template_path
    remove_file(@tmp_filename) # if it exists
  end

  after do
    remove_file(@tmp_filename)
    FileUtils.rmtree(File.join([template_dir, "a"]))
  end

  describe "create_file" do
    should "be able to create an empty file" do
      create_file @tmp_filename
      assert File.exists?(@tmp_filename)
    end

    should "be able to generate multi level directory if it doesn't exist" do
      @tmp_filename = File.join([template_dir, "a", "b", template_file_name])
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
        def initialize(root) @root = root end
        attr_reader :root
      end

      TemplateController.new("", app.new(template_dir)).test_1(template_file_name)
      assert_equal "test_1", File.read(template_path)
    end
  end

  context "template" do

    before do
      @template_file = Tempfile.new(template_file_name, template_dir)
      @app = Class.new do
        def initialize(root, pwd=nil) @root = root; @pwd = pwd end
        attr_reader :root
        attr_reader :pwd
      end

      @rand = rand
      File.open(@template_file, "w+") do |f|
        f.write "template #{@rand}"
      end

    end

    should "generate file from template using absolute directory" do
      @variable = "test_var_for_template"

      template @template_file.path, @tmp_filename
      assert_equal "template #{@rand}", File.open(@tmp_filename, "r").read
    end

    should "use APP_ROOT/app/templates directory if template has relative path" do
       # we will write it in the controller
      empty(@template_file)

      source = template_file_name
      source_full_path = File.join([template_dir, "app/templates", template_file_name])

      create_file(source_full_path) { |f| f.print "template" }
      TemplateController.new("", @app.new(template_dir)).test_template_1(source, @template_file.path)

      remove_file(source_full_path)
      assert_equal "template", File.read(@template_file)
    end

    should "generate file to PWD if target is relative path" do
      TemplateController.new("", @app.new(template_dir, "/tmp")).test_template_1(@template_file.path, template_file_name)
      begin
        assert_equal "template #{@rand}", File.read("/tmp/#{template_file_name}")
      ensure
        remove_file("/tmp/#{template_file_name}")
      end
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
      File.join([template_dir, template_file_name])
    end
  end

  def remove_file(filename)
    FileUtils.remove_file(filename) if File.exists?(filename)
  end

  def empty(file)
    file.truncate(0)
  end

end