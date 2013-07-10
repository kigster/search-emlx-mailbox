require 'spec_helper'

if ENV['TEST_SOLR']
  describe "Search" do
    let(:email_file) { "spec/fixtures/763983.emlx" }

    before do
      EmailSearch::Importer.disable_progress_bar!
    end

    context "searching" do
      it "should be able to search using Solr" do
        search = Email.search { fulltext "Kiggie" }
        search.total.should == 0
        email = EmailSearch::AsciiLoader.new(email_file).email
        email.save!
        Sunspot.commit
        search = Email.search { fulltext "Kiggie" }
        search.total.should == 1
      end
    end
  end
end
