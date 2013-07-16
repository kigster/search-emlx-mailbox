class Email < ActiveRecord::Base
  validates_uniqueness_of :file_name, allow_nil: true

  searchable do
    text :to, :from, :subject
    string :file_name
    text :body do
      body[0..10_000]
    end
    time :received
  end

  def full_body
    header + "\n\n" + body
  end
end
