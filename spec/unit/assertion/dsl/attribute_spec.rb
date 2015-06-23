# encoding: utf-8

describe Assertion::DSL::Attribute do

  let(:klass) do
    Class.new do
      extend Assertion::DSL::Attribute
      attr_reader :foo
    end
  end

  describe ".extended" do

    it "defines the #object" do
      expect(klass.new).to respond_to :object
    end

  end # describe .extended

  describe "#attribute" do

    before { klass.send(:define_method, :object) { :object } }

    shared_examples "aliasing #object" do |with: nil|

      before { klass.attribute with }
      let(:instance) { klass.new }
      subject { instance.send with }

      it { is_expected.to eql instance.object }

    end # shared examples

    shared_examples "complaining about wrong name" do |with: nil|

      subject { klass.attribute with }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of NameError
          expect(error.message).to eql "#{klass}##{with} is already defined"
        end
      end

    end # shared examples

    it_behaves_like "aliasing #object", with: "bar"
    it_behaves_like "complaining about wrong name", with: "foo"
    it_behaves_like "complaining about wrong name", with: "state"

  end # describe #attribute

end # describe Assertion::DSL::Attribute
