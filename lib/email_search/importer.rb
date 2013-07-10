require 'ruby-progressbar'

module EmailSearch
  class Importer
    attr_accessor :folder, :skip_duplicate_file_names, :skip_duplicate_content, :file_extension

    def initialize folder,
        skip_duplicate_file_names: true,
        skip_duplicate_content: true,
        file_extension: DEFAULT_EXTENSION

      self.folder = folder
      self.skip_duplicate_content = skip_duplicate_content
      self.skip_duplicate_file_names = skip_duplicate_file_names
      self.file_extension = file_extension
    end

    class << self
      def disable_progress_bar!
        @progress_bar_enabled = false
      end

      def create_progress_bar(size)
       !defined?(@progress_bar_enabled) || @progress_bar_enabled ?
            ProgressBar.create(title: 'Email Import', total: size, throttle_rate: 0.1) :
            nil
      end

    end

    def import!
      pattern = File.join(folder, "**", "*.#{file_extension}")
      files   = Dir.glob(pattern)
      stats   = Struct.new(:total, :imported, :duplicates).new(0, 0, 0)

      stats.total = files.size

      pb = self.class.create_progress_bar(files.size)

      files.each_slice(1000) do |slice|
        Email.transaction do
          slice.each do |file|
            pb.increment if pb
            email = EmailSearch::AsciiLoader.new(file).email
            next unless email

            if skip_duplicate_content
              duplicate = Email.where("received = ? and \"from\" = ? and \"to\" = ? and subject = ?",
                                      email.received, email.from, email.to, email.subject).first
              if duplicate && duplicate.body[0..1000].eql?(email.body[0..1000])
                stats.duplicates += 1
                next
              end
            end

            if !email.valid? && !email.errors[:file_name].empty? && skip_duplicate_file_names
              stats.duplicates += 1
              next
            end

            stats.imported += 1
            email.save!
          end
        end
      end

      puts "Import Complete: #{stats.total} files, #{stats.duplicates} duplicates, #{stats.imported} imported." if pb
    end

    private
  end
end
