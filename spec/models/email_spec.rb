require 'spec_helper'

describe Email do

  let(:email_file)     { 'spec/fixtures/763983.emlx' }
  let(:email_text_file){ 'spec/fixtures/some_ascii_file.txt' }
  let(:bad_email_file) { 'spec/fixtures/763983-badtime.emlx' }
  let(:email_folder)   { 'spec/fixtures/folder/' }

  before do
    EmailSearch::Importer.disable_progress_bar!
  end

  describe '#from_file' do
    it 'should parse emlx file' do
      email = EmailSearch::AsciiLoader.new(email_file).email
      expect(email).to_not  be_nil

      expect(email).to  be_kind_of(Email)
      expect(email.header).to_not  be_nil
      expect(email.body).to_not  be_nil
      expect(email.subject).to eq('Re: what up')
      expect(email.to).to eql('Kiggie <kig@mwhahahaa.com>')
      expect(email.from).to eql('John Doe <john@boo.ru>')
      expect(email.cc).to eql('james Dalton <james@mwhahahaa.com>, Mike Ass <mike@assswipesters.com>')
      expect(email.received).to eql(Time.parse('Mon, 29 Dec 2008 01:05:35 +0300'))
      expect(email.file_name).to eql('763983.emlx')
      email.save!
    end

    it 'should parse txt file' do
      email = EmailSearch::AsciiLoader.new(email_text_file).email
      expect(email).to_not  be_nil

      expect(email).to  be_kind_of(Email)
      expect(email.header).to_not  be_nil
      expect(email.body).to_not  be_nil
      expect(email.subject).to eql('RE: Boo')
      expect(email.to).to eql('"Mr Sandman" <sandman@playground.com>')
      expect(email.from).to eql('"Dillon, Loxley" <LoxleyDillon@poopmobile.com>')
      expect(email.cc).to  be_nil
      expect(email.file_name).to eql('some_ascii_file.txt')
      email.save!
    end


    it 'should not explode when date is invalid' do
      email = EmailSearch::AsciiLoader.new(bad_email_file).email
      expect(email.received).to  be_nil
      email.save!
    end

    it 'should not load file bigger than max size' do
      allow(File).to receive(:size).and_return(20_000_000)
      email = EmailSearch::AsciiLoader.new(email_file).email
      expect(email).to be_nil
    end

    describe 'duplicate filename' do
      it 'should detect duplicate file name with validation' do
        email = EmailSearch::AsciiLoader.new(email_file).email
        email.save!
        email = EmailSearch::AsciiLoader.new(email_file).email
        expect(email.valid?).to be_falsey
      end
    end
  end

  describe '#create_from_dir' do
    it 'should load multiple emails from directory structure' do
      expect do
        EmailSearch::Importer.new(email_folder).import!
      end.to change { Email.count }.by(2)
    end

    it 'should skip duplicate filenames' do
      expect do
        EmailSearch::Importer.new(email_folder).import!
      end.to change { Email.count }.by(2)
      # do it again
      expect do
        EmailSearch::Importer.new(email_folder).import!
      end.to change { Email.count }.by(0)
      # now throw exception
      expect do
        EmailSearch::Importer.new(email_folder, skip_duplicate_content: false, skip_duplicate_file_names: false ).import!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end
