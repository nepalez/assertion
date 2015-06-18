# encoding: utf-8

describe Assertion::I18n, "#translate" do

  subject { fn[input] }

  let(:fn)     { described_class[:translate, scope, args] }
  let(:args)   { { foo: :FOO } }
  let(:scope)  { double }
  let(:input)  { double }
  let(:output) { double }

  before do
    allow(::I18n)
      .to receive(:t)
      .with(input, foo: :FOO, scope: scope)
      .and_return output
  end

  it "doesn't mutate the input" do
    expect { subject }.not_to change { input }
  end

  it "returns the string converted to snake case" do
    expect(subject).to eql output
  end

end # describe Assertion::I18n#translate
