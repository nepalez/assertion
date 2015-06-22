# encoding: utf-8

describe Assertion::Inflector, "#to_snake" do

  subject { fn[input] }

  let(:fn)     { described_class[:to_snake] }
  let(:input)  { "FooBarBAz___qux" }
  let(:output) { "foo_bar_baz_qux" }

  it "doesn't mutate the input" do
    expect { subject }.not_to change { input }
  end

  it "returns the string converted to snake case" do
    expect(subject).to eql output
  end

end # describe Assertion::Inflector#to_snake
