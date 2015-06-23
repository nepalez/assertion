# encoding: utf-8

describe Assertion::Translator do

  before { class IsFoo; end }
  after  { Object.send :remove_const, :IsFoo }

  subject(:translator) { described_class.new(IsFoo) }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#assertion" do

    subject { translator.assertion }
    it { is_expected.to eql IsFoo }

  end # describe #assertion

  describe "#scope" do

    subject { translator.scope }
    it { is_expected.to eql [:assertion, :is_foo] }

  end # describe #scope

  describe "#call" do

    shared_examples "translating" do |input, to: nil|

      subject { translator.call(input) }

      let(:attributes) { { foo: :FOO, bar: :BAR } }
      let(:output) { "translation missing: en.assertion.is_foo.#{to}" }

      it "provides translation" do
        expect(translator.call input).to eql output
      end

      it "makes arguments available" do
        expect(I18n).to receive(:translate) do |_, args|
          expect(args.merge(attributes)).to eql args
        end
        translator.call input, attributes
      end

    end # shared examples

    it_behaves_like "translating", true,  to: "truthy"
    it_behaves_like "translating", "ok",  to: "truthy"
    it_behaves_like "translating", false, to: "falsey"
    it_behaves_like "translating", nil,   to: "falsey"

  end # describe #call

end # describe Assertion::Translator
