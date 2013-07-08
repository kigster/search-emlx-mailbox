class Email < ActiveRecord::Base
  validates_uniqueness_of :file_name, allow_nil: true

  searchable do
    string :to, :from, :subject
    text :body do
      body[0..10_000]
    end
    time :received
  end

  include EmailLoader

end
