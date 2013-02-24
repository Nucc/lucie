module Lucy
  module Snippets
    module Template
      def create_file(file_path, &block)
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
    end
  end
end