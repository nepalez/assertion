# encoding: utf-8

describe Assertion::List, "#symbolize" do

  subject { fn[input] }

  let(:fn)     { described_class[:symbolize] }
  let(:input)  { [[:foo, "bar"], "foo"] }
  let(:output) { [:foo, :bar] }

  it "doesn't mutate the input" do
    expect { subject }.not_to change { input }
  end

  it "returns the string converted to snake case" do
    expect(subject).to eql output
  end

end # describe Assertion::List#symbolize
