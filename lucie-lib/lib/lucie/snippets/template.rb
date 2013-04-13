require 'erb'
require 'fileutils'

module Lucie
  module Snippets
    module Template
      private
      def create_file(file_path, &block)

        file_path = [app.root, file_path].join("/") if file_path[0] != "/"

        dir_name = File.dirname(file_path)
        if !File.directory?(dir_name)
          FileUtils.mkdir_p(dir_name)
        end

        if block
          File.open(file_path, "a") do |f|
            yield(f)
          end
        else
          File.new(file_path, "a")
        end
      end

      def template(template, target)
        create_file(target) do |f|
          f.write ERB.new(File.read(template)).result(binding)
        end
      end
    end
  end
end