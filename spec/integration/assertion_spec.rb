# encoding: utf-8

require "shared/i18n"

describe Assertion do

  include_context "preloaded translations"

  it "works" do
    IsMale = Assertion.about :name, :gender do
      gender == :male
    end

    IsAdult = Assertion.about :name, :age do
      age.to_i >= 18
    end

    class IsCat < Assertion::Base
      attribute :species, :name

      def check
        species == :cat
      end

      def truthy
        "#{name} is a cat"
      end

      def falsey
        "#{name} is not a cat"
      end
    end

    jane = { name: "Jane", gender: :female, age: 19, species: :human }
    john = { name: "John", gender: :male, age: 9, species: :cat }

    jane_is_a_female = IsMale.not[jane]
    jane_is_an_adult = IsAdult[jane]
    jane_is_a_women  = jane_is_a_female & jane_is_an_adult
    expect(jane_is_a_women).to be_valid
    expect { jane_is_a_women.validate! }.not_to raise_error

    jane_is_a_male   = IsMale[jane]
    jane_is_a_child  = IsAdult.not[jane]
    jane_is_a_boy = jane_is_a_male & jane_is_a_child
    expect(jane_is_a_boy).not_to be_valid
    expect(jane_is_a_boy.messages)
      .to eql ["Jane is a female", "Jane is an adult (age 19)"]
    expect { jane_is_a_boy.validate! }.to raise_error Assertion::InvalidError

    jane_is_a_cat = IsCat[jane]
    expect(jane_is_a_cat.messages).to eql ["Jane is not a cat"]

    john_is_not_a_cat = IsCat.not[john]
    expect(john_is_not_a_cat.messages).to eql ["John is a cat"]
  end

  after do
    Object.send :remove_const, :IsAdult
    Object.send :remove_const, :IsMale
  end

end # describe Assertion
