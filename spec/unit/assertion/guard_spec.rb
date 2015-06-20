# encoding: utf-8

require "ostruct"

describe Assertion::Guard do

  before do
    IsAdult   = Assertion.about(:age) { age.to_i >= 18 }
    AdultOnly = Class.new(described_class) { def state; IsAdult[object]; end }
  end

  let(:valid)   { OpenStruct.new(name: "Joe", age: 40) }
  let(:invalid) { OpenStruct.new(name: "Ian", age: 10) }
  let(:guard)   { AdultOnly.new valid     }

  it "can declare attributes" do
    expect(AdultOnly).to be_kind_of Assertion::Attributes
  end

  describe ".new" do

    subject { guard }

    it { is_expected.to be_frozen }

    context "with an attriubute" do

      before { allow(AdultOnly).to receive(:attributes) { [:foo] } }

      it "adds the alias to the #object" do
        expect(subject.foo).to eql subject.object
      end

    end # context

  end # describe .new

  describe ".[]" do

    it "returns the result of the call" do
      expect(AdultOnly[valid]).to eql valid
      expect { AdultOnly[invalid] }.to raise_error Assertion::InvalidError
    end

  end # describe .[]

  describe "#object" do

    subject { guard.object }

    it { is_expected.to eql valid }

  end # describe #object

  describe "#call" do

    subject { guard.call }

    context "when #state is valid" do

      it { is_expected.to eql valid }

    end # context

    context "when #state is invalid" do

      let(:guard) { AdultOnly.new invalid }

      it "raises InvalidError" do
        expect { subject }.to raise_error Assertion::InvalidError
      end

    end # context

  end # describe #call

  after do
    Object.send :remove_const, :AdultOnly
    Object.send :remove_const, :IsAdult
  end

end # describe Assertion::Guard
