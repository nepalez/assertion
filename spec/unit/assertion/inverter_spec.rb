# encoding: utf-8

describe Assertion::Inverter do

  let(:source) do
    IsMan = Assertion.about(:age, :gender) { age.to_i >= 18 && gender == :male }
  end

  subject(:inverter) { described_class.new source }

  it "implements DSL::Caller" do
    expect(inverter).to be_kind_of Assertion::DSL::Caller
  end

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

  after { Object.send :remove_const, :IsMan }

end # describe Assertion::Inverter
