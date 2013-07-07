require 'ruby-progressbar'

class Email < ActiveRecord::Base
  EXTENSION = "emlx"
  MAX_FILE_SIZE = 10_000_000

  searchable do
    text :to, :from, :subject, :body
    time :received
  end

  class << self

    def progress_bar(size)
      @progress_bar_enabled = true unless defined?(@progress_bar_enabled)
      @progress_bar_enabled ?
          ProgressBar.create(title: 'Email Import', total: size, throttle_rate: 0.1) :
          nil
    end

    def disable_progress_bar!
      @progress_bar_enabled = false
    end
  end


  def self.from_file(filename)
    return if File.size(filename) > MAX_FILE_SIZE
    content = File.read(filename).encode!('UTF-8', 'UTF-8', :invalid => :replace, :replace => '').unpack("C*").pack("U*")
    email = self.new
    email.header, email.body = content.split(/\n\n/, 2)
    email.subject = email.header.scan(/.*\n[Ss]ubject:\s+([^\n]*)/).try(:last).try(:first)
    email.to = email.header.scan(/.*\n[tT][oO]:\s+([^\n]*)/).try(:last).try(:first)
    email.from = email.header.scan(/.*\n[fF]rom:\s+([^\n]*)/).try(:last).try(:first)
    email.cc = email.header.scan(/.*\n[cC][cC]:\s+([^\n]*)/).try(:last).try(:first)
    time_string = email.header.scan(/.*\n[dD]ate:\s+([^\n]*)/).try(:last).try(:first)
    email.received = Time.parse(time_string) rescue nil
    email
  rescue Exception => e
    puts "exception processing file #{filename}"
    raise e
  end

  def self.create_from_dir(folder)
    pattern = File.join(folder, "**", "*.#{EXTENSION}")
    files = Dir.glob(pattern)
    pb = self.progress_bar(files.size)
    files.each do |file|
      email = self.from_file(file)
      email.save! if email
      pb.increment if pb
    end
    pb.finish if pb
  end
end
