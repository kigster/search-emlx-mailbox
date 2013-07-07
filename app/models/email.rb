class Email < ActiveRecord::Base


  def self.from_file(filename)
    content = File.read(filename)
    email = self.new
    email.header, email.body = content.split(/\n\n/, 2)
    email.subject = email.header.scan(/.*\nSubject: ([^\n]*)/).last.first
    email.to = email.header.scan(/.*\nT[oO]: ([^\n]*)/).last.first
    email.from = email.header.scan(/.*\nFrom: ([^\n]*)/).last.first
    email.cc = email.header.scan(/.*\nCC: ([^\n]*)/).last.first
    email.received = Time.parse(email.header.scan(/.*\nDate: ([^\n]*)/).last.first)
    email
  end
end
