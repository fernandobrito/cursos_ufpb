module Rack
  module Test
    class UploadedFile
      def initialize(path, content_type = 'text/plain', binary = false)
        raise "#{path} file does not exist" unless ::File.exist?(path)

        @content_type = content_type
        @original_filename = ::File.basename(path)

        @tempfile = Tempfile.new([@original_filename, ::File.extname(path)])
        @tempfile.set_encoding(Encoding::BINARY) if @tempfile.respond_to?(:set_encoding)
        @tempfile.binmode if binary

        FileUtils.copy_file(path, @tempfile.path)
      end
    end
  end
end
