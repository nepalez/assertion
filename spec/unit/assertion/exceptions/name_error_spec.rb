# encoding: utf-8

describe Assertion::NameError do

  subject(:error) { described_class.new :foo, :bar }

  describe ".new" do

    it { is_expected.to be_kind_of ::NameError }

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#message" do

    subject(:message) { error.message }

    it "returns a proper message" do
      expect(subject)
        .to include "Wrong name(s) for attribute(s): foo, bar"
    end

  end # describe #message

end # describe Assertion::NameError
