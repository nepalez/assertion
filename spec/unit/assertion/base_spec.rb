# encoding: utf-8

describe Assertion::Base do

  let(:klass) { Class.new(described_class) }
  before { allow(klass).to receive(:name) { "Test" } }

  describe ".attributes" do

    subject(:attributes) { klass.attributes }

    it { is_expected.to eql [] }

  end # describe .attributes

  describe ".attribute" do

    subject(:attribute) { klass.attribute names }

    context "with valid name" do

      let(:names) { :foo }

      it "defines the attribute" do
        expect { subject }
          .to change { klass.attributes }
          .to [:foo]
      end

    end # context

    context "with array of names" do

      let(:names) { [:foo, "bar", "foo"] }

      it "defines the attribute" do
        expect { subject }
          .to change { klass.attributes }
          .to [:foo, :bar]
      end

    end # context

    context "with a :check name" do

      let(:names) { [:check] }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of Assertion::NameError
          expect(error.message).to include "check"
        end
      end

    end # context

    context "with a :call name" do

      let(:names) { [:call] }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of Assertion::NameError
          expect(error.message).to include "call"
        end
      end

    end # context

  end # describe .attribute

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

  describe "#message" do

    let(:assertion) { klass.new }

    context "for the truthy state" do

      subject { assertion.message(true) }
      it { is_expected.to eql "translation missing: en.assertion.test.right" }

    end # context

    context "for the falsey state" do

      subject { assertion.message(false) }
      it { is_expected.to eql "translation missing: en.assertion.test.wrong" }

    end # context

    context "by default" do

      it "returns the message for the falsey state" do
        expect(assertion.message).to eql assertion.message(false)
      end

    end # context

  end # describe #message

  describe "#check" do

    subject { klass.new.check }

    it "raises NotImplementedError" do
      expect { subject }.to raise_error do |error|
        expect(error).to be_kind_of Assertion::NotImplementedError
        expect(error.message).to include("Test#check ")
      end
    end

  end # describe #check

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
