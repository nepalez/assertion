# encoding: utf-8

describe Assertion::InvalidError do

  subject(:error) { described_class.new messages }
  let(:messages)  { %w(foo bar) }

  describe ".new" do

    it { is_expected.to be_kind_of ::RuntimeError }

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#message" do

    subject { error.message }

    it "returns a proper message" do
      expect(subject).to include "#{messages.inspect}"
    end

  end # describe #message

  describe "#messages" do

    subject { error.messages }

    it { is_expected.to eql messages }

    it { is_expected.to be_frozen }

    it "doesn't freeze the source messages" do
      expect(messages).not_to be_frozen
    end

  end # describe #message

end # describe Assertion::InvalidError
