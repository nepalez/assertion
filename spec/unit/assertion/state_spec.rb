# encoding: utf-8

require "equalizer"

describe Assertion::State do

  subject(:state) { described_class.new result, messages }
  let(:result)    { false       }
  let(:messages)  { %w(foo bar) }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#valid?" do

    subject { state.valid? }

    context "for truthy state" do

      let(:result) { 1 }
      it { is_expected.to eql true }

    end # context

    context "for falsey state" do

      let(:result) { nil }
      it { is_expected.to eql false }

    end # context

  end # describe #valid?

  describe "#invalid?" do

    let(:result) { 1 }
    subject { state.invalid? }

    context "for truthy state" do

      it { is_expected.to eql false }

    end # context

    context "for falsey state" do

      let(:result) { nil }
      it { is_expected.to eql true }

    end # context

  end # describe #valid?

  describe "#messages" do

    subject { state.messages }

    it { is_expected.to be_frozen }

    it "doesn't freeze the source messages" do
      expect(messages).not_to be_frozen
    end

    context "for a valid state" do

      let(:result) { true }
      it { is_expected.to eql [] }

    end # context

    context "from a single item" do

      let(:messages) { "foo" }
      it { is_expected.to eql %w(foo) }

    end # context

    context "from array of items" do

      let(:messages) { %w(foo bar foo) }
      it { is_expected.to eql %w(foo bar) }

    end # context

  end # describe #messages

  describe "#validate!" do

    subject { state.validate! }

    context "valid state" do

      let(:result) { true }

      it "doesn't raise an error" do
        expect { subject }.not_to raise_error
      end

      it "returns true" do
        expect(subject).to eql true
      end

    end # context

    context "invalid state" do

      let(:result) { false }

      it "raises an error" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of Assertion::InvalidError
          expect(error.messages).to eql messages
        end
      end

    end # context

  end # describe #validate!

  describe "#&" do

    subject { state & described_class.new(other_result, other_messages) }
    let(:other_messages) { %w(baz qux) }

    context "valid + valid" do

      let(:result)       { true }
      let(:other_result) { true }

      it "creates a valid state" do
        expect(subject).to be_kind_of described_class
        expect(subject).to be_valid
      end

      it "carries no messages" do
        expect(subject.messages).to eql []
      end

    end # context

    context "valid + invalid" do

      let(:result)       { true  }
      let(:other_result) { false }

      it "creates invalid state" do
        expect(subject).to be_kind_of described_class
        expect(subject).to be_invalid
      end

      it "carries messages from the invalid state" do
        expect(subject.messages).to eql other_messages
      end

    end # context

    context "invalid + valid" do

      let(:result)       { false }
      let(:other_result) { true  }

      it "creates invalid state" do
        expect(subject).to be_kind_of described_class
        expect(subject).to be_invalid
      end

      it "carries messages from the invalid state" do
        expect(subject.messages).to eql messages
      end

    end # context

    context "invalid + invalid" do

      let(:result)       { false }
      let(:other_result) { false }

      it "creates invalid state" do
        expect(subject).to be_kind_of described_class
        expect(subject).to be_invalid
      end

      it "carries messages from the both states" do
        expect(subject.messages).to eql(messages + other_messages)
      end

    end # context

  end # describe #validate!

  describe "#>>" do

    before do
      described_class.instance_eval { include Equalizer.new(:messages) }
    end

    subject       { state >> described_class.new(false, "quxx") }
    let(:compare) { state & described_class.new(false, "quxx")  }

    it "is an alias for #&" do
      expect(subject).to eq compare
    end

  end # describe #+

  describe "#+" do

    before do
      described_class.instance_eval { include Equalizer.new(:messages) }
    end

    subject       { state + described_class.new(false, "quxx") }
    let(:compare) { state & described_class.new(false, "quxx") }

    it "is an alias for #&" do
      expect(subject).to eq compare
    end

  end # describe #+

end # describe Assertion::State
