module EmailSearch
  DEFAULT_EXTENSION = 'emlx'
  MAX_FILE_SIZE = 10_000_000

  module Output
    def debug(msg)
      STDOUT.puts 'INFO > '.bold.blue + msg + "\n"
    end

    def error (msg)
      STDERR.puts 'ERR  > '.bold.red + msg.yellow + "\n"
    end
  end

  class << self
    include Output
  end
end

require_relative 'email_search/ascii_loader'
require_relative 'email_search/importer'
require_relative 'email_search/cli'
