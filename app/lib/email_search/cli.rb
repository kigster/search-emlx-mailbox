require_relative 'mbox_file'

module EmailSearch
  class CLI
    attr_accessor :argv

    def initialize(*args)
      @argv = args
    end

    def execute
      argv.each_with_index do |file, index|
        EmailSearch::MboxFile.new(file, index).process!
      end
    end
  end
end
