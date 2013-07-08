module SampleDataHelper
  def load_fixture_email
    email = Email.from_file("spec/fixtures/763983.emlx")
    email.save!
    email
  end
end

RSpec.configure do |config|
  config.include(SampleDataHelper)
end
