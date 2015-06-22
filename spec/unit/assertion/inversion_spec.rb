# encoding: utf-8

describe Assertion::Inversion do

  before { IsAdult = Assertion.about(:age) { age >= 18 } }

  let(:assertion)            { IsAdult.new age: 21            }
  subject(:inversion)        { described_class.new(assertion) }
  subject(:double_inversion) { described_class.new(inversion) }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#assertion" do

    subject { inversion.assertion }

    it { is_expected.to eql assertion }

  end # describe #assertion

  describe "#check" do

    subject { instance.check }

    it "is opposite to the assertion#check" do
      expect(inversion.check).to eql !assertion.check
    end

    it "works for double inversion" do
      expect(double_inversion.check).to eql assertion.check
    end

  end # describe #check

  describe "#message" do

    context "for the truthy state" do

      it "is equal to falsey assertion" do
        expect(inversion.message(true)).to eql assertion.message(false)
      end

      it "works for double inversion" do
        expect(double_inversion.message(true)).to eql assertion.message(true)
      end

    end # context

    context "for the falsey state" do

      it "is equal to truthy assertion" do
        expect(inversion.message(false)).to eql assertion.message(true)
      end

      it "works for double inversion" do
        expect(double_inversion.message(false)).to eql assertion.message(false)
      end

    end # context

    context "by default" do

      it "returns the message for the falsey state" do
        expect(inversion.message).to eql inversion.message(false)
      end

    end # context

  end # describe #message

  describe "#call" do

    let(:state) { assertion.call }
    subject     { inversion.call }

    it "creates the state opposite to the assertion's" do
      expect(subject.valid?).to eql state.invalid?
      expect(subject.messages).to contain_exactly assertion.message(true)
    end

  end # describe #call

  after { Object.send :remove_const, :IsAdult }

end # describe Assertion::Inversion
