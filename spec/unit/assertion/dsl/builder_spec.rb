# encoding: utf-8

describe Assertion::DSL::Builder do

  let(:klass) { Class.new { extend Assertion::DSL::Builder } }
  let(:john)  { { age: 17, gender: :male } }
  let(:jack)  { { age: 18, gender: :male } }

  describe "#about" do

    context "with attributes and a block" do

      subject do
        IsMan = klass.about(:age, :gender) { age >= 18 && gender == :male }
      end

      it "builds the assertion class" do
        expect(subject.superclass).to eql Assertion::Base
      end

      it "implements the #check method" do
        expect(subject[john]).to be_invalid
        expect(subject[jack]).to be_valid
      end

    end # context

    context "without attributes" do

      subject do
        IsMan = klass.about { true }
      end

      it "builds the assertion class" do
        expect(subject.superclass).to eql Assertion::Base
      end

      it "implements the #check method" do
        expect(subject[john]).to be_valid
        expect(subject[jack]).to be_valid
      end

    end # context

    context "without a block" do

      subject do
        IsMan = klass.about(:age, :gender)
      end

      it "builds the assertion class" do
        expect(subject.superclass).to eql Assertion::Base
      end

      it "doesn't implement the #check method" do
        expect { subject.new(jack).check }.to raise_error NoMethodError
      end

    end # context

    after { Object.send :remove_const, :IsMan }

  end # describe .about

  describe "#guards" do

    before { IsAdult = klass.about(:age) { age.to_i >= 18 } }

    context "with an attribute and a block" do

      subject { klass.guards(:user) { IsAdult[user] } }

      it "builds the guard class" do
        expect(subject.superclass).to eql Assertion::Guard
      end

      it "defines an alias for the object" do
        expect(subject.new(jack).user).to eql jack
      end

      it "implements the #state" do
        expect { subject.new(jack).state }.not_to raise_error
      end

    end # context

    context "without an attribute" do

      subject { klass.guards { IsAdult[object] } }

      it "builds the guard class" do
        expect(subject.superclass).to eql Assertion::Guard
      end

      it "implements the #state of #object" do
        expect { subject.new(jack).state }.not_to raise_error
      end

    end # context

    context "without a block" do

      subject { klass.guards(:user) }

      it "builds the guard class" do
        expect(subject.superclass).to eql Assertion::Guard
      end

      it "defines an alias for the object" do
        expect(subject.new(jack).user).to eql jack
      end

      it "doesn't implement the #state" do
        expect { subject.new(jack).state }.to raise_error NoMethodError
      end

    end # context

    after { Object.send :remove_const, :IsAdult   }

  end # describe .guards

end # describe Assertion::DSL::Builder
