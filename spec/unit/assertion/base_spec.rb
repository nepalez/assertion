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

  it "implements DSL::Inversion" do
    expect(klass).to be_kind_of Assertion::DSL::Inversion
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

  describe "#message" do

    let(:klass)      { Class.new(described_class) { attribute :foo } }
    let(:assertion)  { klass.new(foo: :FOO)                          }

    shared_examples "translating" do |options|

      let(:translator) { Assertion::Translator.new(klass) }
      let(:attributes) { assertion.attributes             }

      it "uses attributes in a translation" do
        expect(I18n).to receive :translate do |_, args|
          expect(args.merge(attributes)).to eql args
        end
        subject
      end

      it "returns a translation" do
        expect(subject).to eql translator.call(options[:as], attributes)
      end

    end # shared examples

    it_behaves_like "translating", as: true do
      subject { assertion.message(true) }
    end

    it_behaves_like "translating", as: false do
      subject { assertion.message(false) }
    end

    it_behaves_like "translating", as: false do
      subject { assertion.message }
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
