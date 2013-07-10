module SampleDataHelper
  def load_fixture_email
    email = EmailSearch::AsciiLoader.new("spec/fixtures/763983.emlx").email
    email.save!
    email
  end
end

RSpec.configure do |config|
  config.include(SampleDataHelper)
end
