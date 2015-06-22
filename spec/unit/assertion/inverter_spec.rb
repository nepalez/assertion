# encoding: utf-8

describe Assertion::Inverter do

  let(:source) do
    IsMan = Assertion.about(:age, :gender) { age.to_i >= 18 && gender == :male }
  end

  subject(:inverter) { described_class.new source }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe ".source" do

    subject { inverter.source           }
    it      { is_expected.to eql source }

  end # describe .source

  describe "#new" do

    let(:assertion) { inversion.assertion }

    context "with attributes" do

      subject(:inversion) { inverter.new age: 17, gender: :male }

      it "returns an inversion" do
        expect(inversion).to be_kind_of Assertion::Inversion
        expect(assertion.attributes).to eql(age: 17, gender: :male)
      end

    end # context

    context "without attributes" do

      subject(:inversion) { inverter.new }

      it "returns an inversion" do
        expect(inversion).to be_kind_of Assertion::Inversion
        expect(assertion.attributes).to eql(age: nil, gender: nil)
      end

    end # context

  end # describe #new

  describe "#[]" do

    context "with attributes" do

      subject(:state) { inverter[age: 18, gender: :male] }

      it "provides the state for inversion" do
        expect(state).to be_kind_of Assertion::State
        expect(state).to be_invalid
      end

    end # context

    context "without attributes" do

      subject(:state) { inverter[] }

      it "provides the state for inversion" do
        expect(state).to be_kind_of Assertion::State
        expect(state).to be_valid
      end

    end # context

  end # describe #[]

  after { Object.send :remove_const, :IsMan }

end # describe Assertion::Inverter
