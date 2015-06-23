# encoding: utf-8

describe Assertion::Base do

  let(:klass) { Class.new(described_class) }
  before { allow(klass).to receive(:name) { "Test" } }

  it "implements DSL::Caller" do
    expect(klass).to be_kind_of Assertion::DSL::Caller
  end

  it "implements DSL::Attributes" do
    expect(klass).to be_kind_of Assertion::DSL::Attributes
  end

  describe ".new" do

    let(:klass) { Class.new(described_class) { attribute :foo, :bar } }

    context "with attributes" do

      subject { klass.new foo: :FOO, bar: :BAR, baz: :BAZ }

      it "defines attributes" do
        new_methods = subject.methods - described_class.instance_methods
        expect(new_methods).to match_array [:foo, :bar]
      end

      it "initializes attributes" do
        expect(subject.foo).to eql :FOO
        expect(subject.bar).to eql :BAR
      end

      it { is_expected.to be_frozen }

    end # context

    context "without attributes" do

      subject { klass.new }

      it { is_expected.to be_frozen }

    end # context

  end # describe .new

  describe ".not" do

    subject { klass.not }

    it "creates the iverter for the current class" do
      expect(subject).to be_kind_of Assertion::Inverter
      expect(subject.source).to eql klass
    end

  end # describe .not

  describe ".translator" do

    subject { klass.translator }

    it { is_expected.to be_kind_of Assertion::Translator }

    it "refers to the current class" do
      expect(subject.assertion).to eql klass
    end

  end # describe .translator

  describe "#message" do

    let(:attrs)      { { foo: :FOO, bar: :BAR } }
    let(:klass)      { Class.new(described_class) { attribute :foo, :bar } }
    let(:assertion)  { klass.new attrs }
    let(:translator) { double call: nil }

    context "with a state" do

      let(:state) { double }
      after { assertion.message(state) }

      it "calls a translator with state and attributes" do
        allow(klass).to receive(:translator) { translator }
        expect(translator).to receive(:call).with(state, attrs)
      end

    end # context

    context "without a state" do

      after { assertion.message }

      it "calls a translator with nil" do
        allow(klass).to receive(:translator) { translator }
        expect(translator).to receive(:call).with(nil, attrs)
      end

    end # context

  end # describe #message

  describe "#call" do

    subject { assertion.call }

    context "invalid assertion" do

      let(:assertion) do
        klass.__send__(:define_method, :check) { false }
        klass.new
      end

      it "returns an invalid state" do
        expect(subject).to be_kind_of Assertion::State
        expect(subject).to be_invalid
      end

      it "adds a proper message to the state" do
        expect(subject.messages).to contain_exactly assertion.message(false)
      end

    end # context

    context "valid assertion" do

      let(:assertion) do
        klass.__send__(:define_method, :check) { true }
        klass.new
      end

      it "returns a valid state" do
        expect(subject).to be_kind_of Assertion::State
        expect(subject).to be_valid
      end

    end # context

  end # describe #call

end # describe Assertion
