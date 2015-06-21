# encoding: utf-8

describe Assertion::Messages, "#message" do

  let(:test_klass)  { Test = Class.new { include Assertion::Messages } }
  let(:instance)    { test_klass.new                                   }

  shared_examples "translating" do |state, as: nil|

    subject(:message) { instance.message(state) }

    it { is_expected.to eql "translation missing: en.assertion.test.#{as}" }

    it "sends attributes to translation" do
      expect(I18n).to receive(:translate) do |_, args|
        expect(args.merge(instance.attributes)).to eql args
      end
      subject
    end

  end # shared examples

  context "without attributes" do

    it_behaves_like "translating", true,  as: "truthy"
    it_behaves_like "translating", false, as: "falsey"

  end # context

  context "with attributes" do

    before { test_klass.send(:define_method, :attributes) { { foo: :FOO } } }

    it_behaves_like "translating", true,  as: "truthy"
    it_behaves_like "translating", false, as: "falsey"

  end # context

  after { Object.send :remove_const, :Test }

end # describe Assertion::Messages
