# encoding: utf-8

describe Assertion::I18n, "#scope" do

  subject { fn[input] }

  let(:fn)     { described_class[:scope] }
  let(:input)  { "Foo::BarBaz" }
  let(:output) { [:assertion, :"foo/bar_baz"] }

  it "doesn't mutate the input" do
    expect { subject }.not_to change { input }
  end

  it "returns the class scope" do
    expect(subject).to eql output
  end

end # describe Assertion::I18n#scope
