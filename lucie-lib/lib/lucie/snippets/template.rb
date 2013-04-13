require 'erb'
require 'fileutils'

module Lucie
  module Snippets
    module Template

    protected

      # that would be great if we occurre the Helper init in every method, but
      # now I don't know nice solution for this

      def create_file(file_path, &block)
        @file_utils_helper ||= FileUtilsHelper.new(self)
        @file_utils_helper.create_file(file_path, &block)
      end

      def template(template, target)
        @file_utils_helper ||= FileUtilsHelper.new(self)
        create_file(target) do |f|
          f.write ERB.new(File.read(template)).result(binding)
        end
      end

    private

      class FileUtilsHelper

        def initialize(controller)
          @controller = controller
        end

        def create_file(path, &content)
          path = normalized path
          create_dir_for path
          add_content_to_file path, &content
        end

        def is_relative?(file_path)
          file_path[0] != "/"
        end

        def normalized(path)
          if is_relative?(path)
            [@controller.app.root, path].join("/")
          else
            path
          end
        end

        def create_dir_for(file_path)
          dir_name = File.dirname(file_path)
          if !File.directory?(dir_name)
            FileUtils.mkdir_p(dir_name)
          end
        end

        def add_content_to_file(path, &content)
          block_given? && File.open(path, "a") { |f| yield f } || File.new(path, "a")
        end

      end

    end
  end
end