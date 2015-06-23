# encoding: utf-8

describe Assertion do

  it "extends DSL::Builder" do
    expect(described_class).to be_kind_of Assertion::DSL::Builder
  end

end # describe Assertion
