module EmailLoader
  EXTENSION = "emlx"
  MAX_FILE_SIZE = 10_000_000

  extend ActiveSupport::Concern

  module ClassMethods
    def from_file(filepath)
      return if File.size(filepath) > MAX_FILE_SIZE
      content = File.read(filepath).encode!('UTF-8', 'UTF-8', :invalid => :replace, :replace => '').unpack("C*").pack("U*")
      email = self.new
      email.header, email.body = content.split(/\n\n/, 2)
      email.subject = email.header.scan(/.*\n[Ss]ubject:\s+([^\n]*)/).try(:last).try(:first)
      email.to = email.header.scan(/.*\n[tT][oO]:\s+([^\n]*)/).try(:last).try(:first)
      email.from = email.header.scan(/.*\n[fF]rom:\s+([^\n]*)/).try(:last).try(:first)
      email.cc = email.header.scan(/.*\n[cC][cC]:\s+([^\n]*)/).try(:last).try(:first)
      email.file_name = file_name(filepath)
      time_string = email.header.scan(/.*\n[dD]ate:\s+([^\n]*)/).try(:last).try(:first)
      email.received = Time.parse(time_string) rescue nil
      email
    rescue Exception => e
      puts "exception processing file #{filepath}"
      raise e
    end

    def file_name(filepath)
      filepath =~ /\.emlx$/ ? filepath.scan(%r{.*/([\w-]+)\.emlx}).last.first : nil
    end

    def create_from_dir(
        folder,
        skip_duplicate_file_name: true,
        skip_duplicates: true)

      pattern = File.join(folder, "**", "*.#{EXTENSION}")

      files = Dir.glob(pattern)

      stats = Struct.new(:imported, :duplicates).new(0, 0)
      pb = self.progress_bar(files.size)

      files.each_slice(1000) do |slice|
        Email.transaction do
          slice.each do |file|
            pb.increment if pb
            email = self.from_file(file)
            next unless email

            if skip_duplicates
              duplicate = Email.where("received = ? and \"from\" = ? and \"to\" = ? and subject = ?",
                                      email.received, email.from, email.to, email.subject).first
              if duplicate && duplicate.body[0..1000].eql?(email.body[0..1000])
                stats.duplicates += 1
                next
              end
            end

            if !email.valid? && !email.errors[:file_name].empty? && skip_duplicate_file_name
              stats.duplicates += 1
              next
            end

            email.save!
          end
        end
      end

      pb.finish if pb

    end

  end
end
