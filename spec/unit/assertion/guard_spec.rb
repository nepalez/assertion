# encoding: utf-8

require "ostruct"

describe Assertion::Guard do

  before do
    IsAdult   = Assertion.about(:age) { age.to_i >= 18 }
    AdultOnly = Class.new(described_class) do
      def state
        IsAdult[object.to_h]
      end
    end
  end

  let(:valid)   { OpenStruct.new(name: "Joe", age: 40) }
  let(:invalid) { OpenStruct.new(name: "Ian", age: 10) }
  let(:guard)   { AdultOnly.new valid }

  describe ".attribute" do

    shared_examples "adding #object alias" do |name|

      subject { AdultOnly.attribute name }

      it "adds alias for the #object" do
        subject
        expect(guard.send name).to eql guard.object
      end

    end # shared examples

    shared_examples "raising NameError" do |with: nil|

      subject { AdultOnly.attribute with }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of NameError
          expect(error.message).to eql "AdultOnly##{with} is already defined"
        end
      end

    end # shared examples

    it_behaves_like "adding #object alias", :foo
    it_behaves_like "raising NameError", with: :state
    it_behaves_like "raising NameError", with: :call

  end # describe .attribute

  describe ".new" do

    subject { guard }

    it { is_expected.to be_frozen }

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
