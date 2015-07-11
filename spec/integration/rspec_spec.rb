# encoding: utf-8

require "shared/i18n"
require "assertion/rspec"

describe "shared examples" do

  include_context "preloaded translations"

  before do
    IsAdult = Assertion.about :name, :age do
      age.to_i >= 18
    end

    AdultOnly = Assertion.guards :user do
      IsAdult[user]
    end
  end

  it_behaves_like :validating_attributes do
    let(:assertion)  { IsAdult                  }
    let(:attributes) { { name: "Joe", age: 18 } }
    let(:locale)     { :en                      }

    subject(:valid)  { true }
  end

  it_behaves_like :validating_attributes do
    let(:assertion)    { IsAdult                  }
    let(:attributes)   { { name: "Joe", age: 10 } }
    let(:locale)       { :en                      }

    subject(:valid)    { false                     }
    subject(:messages) { "Joe is a child (age 10)" }
  end

  it_behaves_like :validating_attributes do
    let(:described_class) { IsAdult              }
    let(:attributes)  { { name: "Joe", age: 10 } }
    let(:locale)      { :fr                      }

    subject(:messages) { ["Joe est un enfant (10 ans)"] }
  end

  it_behaves_like :validating_attributes do
    let(:assertion)   { IsAdult.not               }
    let(:attributes)  { { name: "Joe", age: 18 }  }
    let(:locale)      { :fr                       }

    subject(:valid)    { false                       }
    subject(:messages) { ["Joe est majeur (18 ans)"] }
  end

  it_behaves_like :accepting_object do
    let(:guard)  { AdultOnly                }
    let(:object) { { name: "Joe", age: 18 } }

    subject(:accepted) { true }
  end

  it_behaves_like :accepting_object do
    let(:guard)  { AdultOnly                }
    let(:object) { { name: "Joe", age: 10 } }
    let(:locale) { :fr                      }

    subject(:accepted) { false                          }
    subject(:messages) { ["Joe est un enfant (10 ans)"] }
  end

  after do
    Object.send :remove_const, :AdultOnly
    Object.send :remove_const, :IsAdult
  end

end # describe Assertion
