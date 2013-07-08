class Email < ActiveRecord::Base
  validates_uniqueness_of :file_name, allow_nil: true

  searchable do
    text :to, :from, :subject
    text :body do
      body[0..10_000]
    end
    time :received
  end

  include EmailLoader

  def file_name_with_extension
    "#{file_name}.#{EmailLoader::EXTENSION}"
  end

  def full_body
    header + "\n\n" + body
  end
end
