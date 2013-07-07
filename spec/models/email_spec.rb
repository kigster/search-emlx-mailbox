require 'spec_helper'

describe Email do
  let(:email_file) { "spec/fixtures/763983.emlx" }

  it "should parse emlx file" do
    email = Email.from_file(email_file)
    email.should_not be_nil
    email.should be_kind_of(Email)
    email.header.should_not be_nil
    email.body.should_not be_nil
    email.subject.should == "Re: Changes on demo"
    email.to.should == "Konstantin Gredeskoul <kig@dropinmedia.com>"
    email.from.should == "Vyacheslav Soldatov <soldatov@sertolovo.ru>"
    email.cc.should == "Tony Rose <tony@dropinmedia.com>, Mike Hannegan <mike@pinkfrosty.com>"
    email.received.should == Time.parse("Mon, 29 Dec 2008 01:05:35 +0300")
    email.save!
  end
end
