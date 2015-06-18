# encoding: utf-8

describe Assertion do

  let(:load_path) { Dir[File.expand_path "../*.yml", __FILE__] }

  around do |example|
    old_locale, I18n.locale = I18n.locale, :en
    old_path, I18n.load_path = I18n.load_path, load_path
    I18n.backend.load_translations

    example.run

    I18n.locale    = old_locale
    I18n.load_path = old_path
  end

  it "works" do
    IsMale = Assertion.about :name, :gender do
      gender == :male
    end

    IsAdult = Assertion.about :name, :age do
      age.to_i >= 18
    end

    jane = { name: "Jane", gender: :female, age: 19 }

    jane_is_a_male   = IsMale[jane]
    jane_is_a_female = IsMale.not[jane]
    jane_is_an_adult = IsAdult[jane]
    jane_is_a_child  = IsAdult.not[jane]

    jane_is_a_women  = jane_is_a_female & jane_is_an_adult
    expect(jane_is_a_women).to be_valid
    expect { jane_is_a_women.validate! }.not_to raise_error

    jane_is_a_boy = jane_is_a_male & jane_is_a_child
    expect(jane_is_a_boy).not_to be_valid
    expect(jane_is_a_boy.messages)
      .to eql ["Jane is a female", "Jane is an adult (age 19)"]
    expect { jane_is_a_boy.validate! }.to raise_error Assertion::InvalidError
  end

  after do
    Object.send :remove_const, :IsAdult
    Object.send :remove_const, :IsMale
  end

end # describe Assertion
