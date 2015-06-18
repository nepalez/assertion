# encoding: utf-8

describe Assertion::Inflector, "#to_path" do

  subject { fn[input] }

  let(:fn)     { described_class[:to_path] }
  let(:input)  { "::/Foo-bar::baz/qux" }
  let(:output) { "Foo/bar/baz/qux" }

  it "doesn't mutate the input" do
    expect { subject }.not_to change { input }
  end

  it "returns the string converted to snake case" do
    expect(subject).to eql output
  end

end # describe Assertion::Inflector#to_path
