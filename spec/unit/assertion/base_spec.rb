# encoding: utf-8

describe Assertion::Base do

  let(:klass) { Class.new(described_class) }
  before { allow(klass).to receive(:name) { "Test" } }

  it "can declare attributes" do
    expect(klass).to be_kind_of Assertion::Attributes
  end

  it "can translate states" do
    expect(klass).to include Assertion::Messages
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

  describe ".[]" do

    subject { klass[params] }

    let(:params)    { { foo: :FOO }      }
    let(:state)     { double             }
    let(:assertion) { double call: state }

    before { allow(klass).to receive(:new).with(params) { assertion } }

    it "checks the assertion for given attributes" do
      expect(subject).to eql state
    end

  end # describe .[]

  describe "#attributes" do

    let(:attrs)     { { foo: :FOO, bar: :BAR } }
    let(:klass)     { Class.new(described_class) { attribute :foo, :bar } }
    let(:assertion) { klass.new attrs }

    subject { assertion.attributes     }
    it      { is_expected.to eql attrs }

  end # describe #attributes

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
