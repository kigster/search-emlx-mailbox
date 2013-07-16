require 'spec_helper'

if ENV['TEST_SOLR']
  describe "Search" do
    let(:email_file) { "spec/fixtures/763983.emlx" }

    before do
      EmailSearch::Importer.disable_progress_bar!
    end

    def create_emails
      EmailSearch::AsciiLoader.new(email_file).email.save!
      Sunspot.commit
    end

    context "while using solr" do
      it "should allow search by full text name or body" do
        search = Email.search { fulltext "Kiggie" }
        search.total.should == 0
        create_emails
        search = Email.search { fulltext "Kiggie" }
        search.total.should == 1
      end
      it "should allow search by file name" do
        search = Email.search { with :file_name, "763983.emlx" }
        search.total.should == 0
        create_emails
        search = Email.search { with :file_name, "763983.emlx" }
        search.total.should == 1
      end
    end
  end
end
