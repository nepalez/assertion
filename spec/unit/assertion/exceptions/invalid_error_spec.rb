# encoding: utf-8

describe Assertion::InvalidError do

  subject(:error) { described_class.new messages }
  let(:messages)  { %w(foo bar) }

  describe ".new" do

    it { is_expected.to be_kind_of ::RuntimeError }

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#messages" do

    subject { error.messages }

    it { is_expected.to eql messages }

    it { is_expected.to be_frozen }

    it "doesn't freeze the source messages" do
      expect(messages).not_to be_frozen
    end

  end # describe #message

  describe "#inspect" do

    subject { error.inspect }

    it "returns a verbose string" do
      expect(subject)
        .to eql "<Assertion::InvalidError @messages=[\"foo\", \"bar\"]>"
    end

  end # describe #inspect

end # describe Assertion::InvalidError
