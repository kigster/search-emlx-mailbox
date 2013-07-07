require 'spec_helper'

describe Email do
  let(:email_file) { "spec/fixtures/763983.emlx" }
  let(:email_folder) { "spec/fixtures/folder/" }

  before do
    Email.disable_progress_bar!
  end

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

  it "should load multiple emails from directory structure" do
    expect do
      Email.create_from_dir(email_folder)
    end.to change{Email.count}.by(2)
  end

end
