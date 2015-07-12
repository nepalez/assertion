# encoding: utf-8

require "ostruct"

describe Assertion::Guard do

  before do
    IsAdult   = Assertion.about(:age) { age.to_i >= 18 }
    AdultOnly = Class.new(described_class) do
      def state
        IsAdult[name: object.name, age: object.age]
      end
    end
  end

  let(:valid)   { OpenStruct.new(name: "Joe", age: 40) }
  let(:invalid) { OpenStruct.new(name: "Ian", age: 10) }
  let(:guard)   { AdultOnly.new valid }

  it "implements DSL::Caller" do
    expect(AdultOnly).to be_kind_of Assertion::DSL::Caller
  end

  it "implements DSL::Attribute" do
    expect(AdultOnly).to be_kind_of Assertion::DSL::Attribute
  end

  describe ".new" do

    subject { guard }

    it "initializes the object" do
      expect(guard.object).to eql valid
    end

    it { is_expected.to be_frozen }

  end # describe .new

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
