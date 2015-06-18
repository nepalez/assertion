# encoding: utf-8

describe Assertion::NotImplementedError do

  subject(:error) { described_class.new klass, :foo }
  let(:klass)     { double name: :Test }

  describe ".new" do

    it { is_expected.to be_kind_of ::NotImplementedError }

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#message" do

    subject(:message) { error.message }

    it "returns a proper message" do
      expect(subject).to include "Test#foo method not implemented"
    end

  end # describe #message

end # describe Assertion::NotImplementedError
