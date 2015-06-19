# encoding: utf-8

describe Assertion::Attributes do

  subject(:klass) do
    class Test
      extend Assertion::Attributes
      attr_reader :baz, :qux
    end

    Test
  end

  describe "#attributes" do

    subject { klass.attributes }

    it { is_expected.to eql [] }

  end # describe #attributes

  describe "#attribute" do

    context "single attribute" do

      subject do
        klass.attribute "foo"
        klass.attribute "bar"
      end

      it "register the attribute" do
        expect { subject }.to change { klass.attributes }.to [:foo, :bar]
      end

    end # context

    context "list of attributes" do

      subject { klass.attribute :foo, :bar }

      it "register the attributes" do
        expect { subject }.to change { klass.attributes }.to [:foo, :bar]
      end

    end # context

    context "array of attributes" do

      subject { klass.attribute %w(foo bar) }

      it "register the attributes" do
        expect { subject }.to change { klass.attributes }.to [:foo, :bar]
      end

    end # context

    context "name of instance method" do

      subject { klass.attribute :baz, :qux }

      it "raises NameError" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of NameError
          expect(error.message)
            .to eql "Wrong name(s) for attribute(s): baz, qux"
        end
      end

    end # context

    context "forbidden attribute" do

      before do
        class Test
          def self.__forbidden_attributes__
            [:foo, :bar]
          end
        end
      end

      subject { klass.attribute :foo, :bar }

      it "raises NameError" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of NameError
          expect(error.message)
            .to eql "Wrong name(s) for attribute(s): foo, bar"
        end
      end

    end # context

  end # describe #attributes

  after { Object.send :remove_const, :Test }

end # describe Assertion::Attributes
