# encoding: utf-8

describe Assertion do

  describe ".about" do

    let(:john) { { age: 17, gender: :male } }
    let(:jack) { { age: 18, gender: :male } }

    context "with attributes and a block" do

      subject do
        Man = Assertion.about(:age, :gender) { age >= 18 && gender == :male }
      end

      it "provides the assertion class" do
        expect(subject.superclass).to eql Assertion::Base
      end

      it "implements the #check method" do
        expect(subject[john]).to be_invalid
        expect(subject[jack]).to be_valid
      end

    end # context

    context "without attributes" do

      subject do
        Man = Assertion.about { true }
      end

      it "provides the assertion class" do
        expect(subject.superclass).to eql Assertion::Base
      end

      it "implements the #check method" do
        expect(subject[john]).to be_valid
        expect(subject[jack]).to be_valid
      end

    end # context

    context "without a block" do

      subject do
        Man = Assertion.about(:age, :gender)
      end

      it "provides the assertion class" do
        expect(subject.superclass).to eql Assertion::Base
      end

      it "doesn't implement the #check method" do
        expect { subject[jack] }
          .to raise_error Assertion::NotImplementedError
      end

    end # context

    after { Object.send :remove_const, :Man }

  end # describe .about

end # describe Assertion
