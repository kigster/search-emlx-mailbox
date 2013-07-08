require 'ruby-progressbar'

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


end
