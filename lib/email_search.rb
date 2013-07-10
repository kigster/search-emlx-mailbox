module EmailSearch
  DEFAULT_EXTENSION = "emlx"
  MAX_FILE_SIZE = 10_000_000
end

require_relative 'email_search/ascii_loader'
require_relative 'email_search/importer'
