require 'spec_helper'

describe Email do

  let(:email_file)     { "spec/fixtures/763983.emlx" }
  let(:bad_email_file) { "spec/fixtures/763983-badtime.emlx" }
  let(:email_folder)   { "spec/fixtures/folder/" }

  before do
    Email.disable_progress_bar!
  end

  describe "#from_file" do
    it "should parse emlx file" do
      email = Email.from_file(email_file)
      email.should_not be_nil
      email.should be_kind_of(Email)
      email.header.should_not be_nil
      email.body.should_not be_nil
      email.subject.should == "Re: what up"
      email.to.should == "Kiggie <kig@mwhahahaa.com>"
      email.from.should == "John Doe <john@boo.ru>"
      email.cc.should == "james Dalton <james@mwhahahaa.com>, Mike Ass <mike@assswipesters.com>"
      email.received.should == Time.parse("Mon, 29 Dec 2008 01:05:35 +0300")
      email.save!
    end


    it "should not explode when date is invalid" do
      email = Email.from_file(bad_email_file)
      email.received.should be_nil
      email.save!
    end

    it "should not explode when date is invalid" do
      email = Email.from_file(bad_email_file)
      email.received.should be_nil
      email.save!
    end

    it "should not load file bigger than max size" do
      allow(File).to receive(:size).and_return(20_000_000)
      email = Email.from_file(email_file)
      email.should be_nil
    end

    describe "duplicate filename" do
      it "should detect duplicate file name with validation" do
        email = Email.from_file(email_file)
        email.save!
        email = Email.from_file(email_file)
        email.valid?.should_not be_true
      end
    end
  end

  describe "#create_from_dir" do
    it "should load multiple emails from directory structure" do
      expect do
        Email.create_from_dir(email_folder)
      end.to change { Email.count }.by(2)
    end

    it "should skip duplicate filenames" do
      expect do
        Email.create_from_dir(email_folder)
      end.to change { Email.count }.by(2)
      # do it again
      expect do
        Email.create_from_dir(email_folder)
      end.to change { Email.count }.by(0)
      # now throw exception
      expect do
        Email.create_from_dir(email_folder, skip_duplicates: false, skip_duplicate_file_name: false )
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  describe "#filename" do
    it "should properly extract file name from the file path" do
      filepath = "/asdf/asdfsa/asdfsdf/fjk3ji/23423423.emlx"
      Email.file_name(filepath).should == "23423423"
    end
  end

end
