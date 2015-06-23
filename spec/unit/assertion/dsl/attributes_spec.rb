# encoding: utf-8

require "ostruct"

describe Assertion::DSL::Attributes do

  let(:klass) do
    Class.new do
      extend Assertion::DSL::Attributes
      attr_reader :baz
    end
  end

  describe ".extended" do

    subject { klass.new.attributes }

    it "defines hash of #attributes" do
      expect(subject).to eql({})
    end

  end # describe .extended

  describe "#attributes" do

    subject { klass.attributes }

    it { is_expected.to eql [] }

  end # describe .attributes

  describe "#attribute" do

    before do
      klass.send(:define_method, :attributes) { { foo: :FOO, bar: :BAR } }
    end

    shared_examples "defining attributes" do

      let(:instance) { klass.new }

      it "registers attributes" do
        expect(klass.attributes).to eql [:foo, :bar]
      end

      it "declares attributes" do
        expect(instance.foo).to eql :FOO
        expect(instance.bar).to eql :BAR
      end

    end # shared examples

    shared_examples "complaining about wrong name" do

      subject { klass.attribute name }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of NameError
          expect(error.message).to eql "#{klass}##{name} is already defined"
        end
      end

    end # shared examples

    it_behaves_like "defining attributes" do
      before { klass.attribute :foo }
      before { klass.attribute :bar }
    end

    it_behaves_like "defining attributes" do
      before { klass.attribute :foo, :bar }
    end

    it_behaves_like "defining attributes" do
      before { klass.attribute %w(foo bar) }
    end

    it_behaves_like "complaining about wrong name" do
      let(:name) { "baz" }
    end

    it_behaves_like "complaining about wrong name" do
      let(:name) { "check" }
    end

  end # describe .attribute

end # describe Assertion::DSL::Attributes
