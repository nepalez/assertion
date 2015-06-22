# encoding: utf-8

describe Assertion::Base do

  let(:klass) { Class.new(described_class) }
  before { allow(klass).to receive(:name) { "Test" } }

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

  describe ".attributes" do

    subject { klass.attributes }
    it { is_expected.to eql [] }

  end # describe .attributes

  describe ".attribute" do

    shared_examples "defining attributes" do

      it "registers attributes" do
        expect { subject }.to change { klass.attributes }.to [:foo, :bar]
      end

      it "declares attributes" do
        subject
        assertion = klass.new(foo: :FOO, bar: :BAR, baz: :BAZ)
        expect(assertion.attributes).to eql(foo: :FOO, bar: :BAR)
        expect(assertion.foo).to eql :FOO
        expect(assertion.bar).to eql :BAR
      end

    end # shared examples

    shared_examples "raising NameError" do |with: nil|

      it "fails" do
        expect { subject }.to raise_error do |exception|
          expect(exception).to be_kind_of NameError
          expect(exception.message).to eql "#{klass}##{with} is already defined"
        end
      end

    end # shared examples

    context "with a single name" do

      subject do
        klass.attribute :foo
        klass.attribute "bar"
      end
      it_behaves_like "defining attributes"

    end # context

    context "with a list of names" do

      subject { klass.attribute :foo, :bar }
      it_behaves_like "defining attributes"

    end # context

    context "with an array of names" do

      subject { klass.attribute %w(foo bar) }
      it_behaves_like "defining attributes"

    end # context

    context ":check" do

      subject { klass.attribute :check }
      it_behaves_like "raising NameError", with: :check

    end # context

    context ":call" do

      subject { klass.attribute :call }
      it_behaves_like "raising NameError", with: :call

    end # context

  end # describe .attribute

  describe ".not" do

    subject { klass.not }

    it "creates the iverter for the current class" do
      expect(subject).to be_kind_of Assertion::Inverter
      expect(subject.source).to eql klass
    end

  end # describe .not

  describe ".[]" do

    let(:params)    { { foo: :FOO }      }
    let(:state)     { double             }
    let(:assertion) { double call: state }

    context "with params" do

      subject { klass[params] }

      it "checks the assertion for given attributes" do
        allow(klass).to receive(:new).with(params) { assertion }
        expect(subject).to eql state
      end

    end # context

    context "without params" do

      subject { klass[] }

      it "checks the assertion" do
        allow(klass).to receive(:new) { assertion }
        expect(subject).to eql state
      end

    end # context

  end # describe .[]

  describe ".translator" do

    subject { klass.translator }

    it { is_expected.to be_kind_of Assertion::Translator }

    it "refers to the current class" do
      expect(subject.assertion).to eql klass
    end

  end # describe .translator

  describe "#attributes" do

    let(:attrs)     { { foo: :FOO, bar: :BAR } }
    let(:klass)     { Class.new(described_class) { attribute :foo, :bar } }
    let(:assertion) { klass.new attrs }

    subject { assertion.attributes     }
    it      { is_expected.to eql attrs }

  end # describe #attributes

  describe "#message" do

    let(:state)      { double }
    let(:attrs)      { { foo: :FOO, bar: :BAR } }
    let(:klass)      { Class.new(described_class) { attribute :foo, :bar } }
    let(:assertion)  { klass.new attrs }
    let(:translator) { double call: nil }

    it "calls a translator with state and attributes" do
      allow(klass).to receive(:translator) { translator }
      expect(translator).to receive(:call).with(state, attrs)
      assertion.message(state)
    end

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
