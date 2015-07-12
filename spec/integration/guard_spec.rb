# encoding: utf-8

require "ostruct"
require "shared/i18n"

describe Assertion do

  include_context "preloaded translations"

  it "works" do
    IsAdult = Assertion.about :name, :age do
      age.to_i >= 18
    end

    AdultOnly = Assertion.guards :user do
      IsAdult[name: user.name, age: user.age]
    end

    andrew = OpenStruct.new(name: "Andrew", age: 13, city: "Moscow")
    andriy = OpenStruct.new(name: "Andriy", age: 28, city: "Kiev")

    expect { AdultOnly[andrew] }.to raise_error Assertion::InvalidError
    expect(AdultOnly[andriy]).to eql andriy
  end

  after { Object.send :remove_const, :AdultOnly }
  after { Object.send :remove_const, :IsAdult   }

end # describe Assertion
