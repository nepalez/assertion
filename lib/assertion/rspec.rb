# encoding: utf-8

# ==============================================================================
# Collection of shared examples for testing assertions and guards
# ==============================================================================

shared_context :assertion_translations do

  def lang
    defined?(locale) ? locale : :en
  end

  # allows to skip check for error messages
  def errors
    defined?(messages) ? Array[*messages] : nil
  end

  around do |example|
    old, I18n.locale = I18n.locale, lang
    example.run
    I18n.locale = old
  end

end # shared context

# Specifies the assertion
#
# @example
#   it_behaves_like :validating_attributes do
#     let(:assertion)  { IsAdult                      }
#     let(:attributes) { { name: "Joe", age: 10 }     } # {} by default
#     let(:locale)     { :fr                          } # :en by default
#     let(:message)    { "Joe est un enfant (10 ans)" } # optional
#     let(:valid)      { false                        } # false by default
#   end
#
#   describe IsAdult do # `described_class` will be used instead of `assertion`
#     it_behaves_like :validating_attributes do
#       let(:attributes) { { name: "Joe", age: 18 } }
#       let(:valid)      { true                     }
#     end
#
#     it_behaves_like :validating_attributes do
#       let(:attributes) { { name: "Joe", age: 10 } }
#       let(:message)    { "Joe is adult (age 10)"  }
#     end
#   end
shared_examples :validating_attributes do

  # allows to skip `assertion` definition when described_class is defined
  def klass
    defined?(assertion) ? assertion : described_class
  end

  # allows to skip `valid` definition to test messages only
  def result
    defined?(valid) ? valid : false
  end

  subject(:state) { klass[attributes] }

  include_context :assertion_translations

  it "[validates]" do
    expect(state.valid?).to eql(result), <<-REPORT.gsub(/.+\|/, "")
      |
      |#{klass}[#{attributes.to_s[1..-2]}]
      |
      |  expected: to be #{result ? "valid" : "invalid"}
      |       got: #{state.valid? ? "valid" : "invalid"}
    REPORT
  end

  it "[raises expected message]" do
    if !result && state.invalid? && errors
      expect(state.messages)
        .to match_array(errors), <<-REPORT.gsub(/.+\|/, "")
          |
          |Language: #{locale.to_s.upcase}
          |Error messages from #{klass}[#{attributes.to_s[1..-2]}]
          |
          |  expected: #{errors.inspect}
          |       got: #{state.messages.inspect}
        REPORT
    end
  end

end # shared examples

# Specifies the guard
#
# @example
#   it_behaves_like :accepting_object do
#     let(:guard)  { AdultOnly                }
#     let(:object) { { name: "Joe", age: 10 } }
#     let(:locale) { :fr                      }
#
#     subject(:accepted) { false }
#     subject(:messages) { [""]  }
#   end
#
shared_examples :accepting_object do

  # allows to skip `guard` definition when described_class is defined
  def klass
    defined?(guard) ? guard : described_class
  end

  # allows to skip `valid` definition to test messages only
  def result
    defined?(accepted) ? accepted : false
  end

  subject(:checkup) { guard[object] }

  include_context :assertion_translations

  it "[guards]" do
    if result
      expect { checkup }
        .not_to raise_error, <<-REPORT.gsub(/.+\|/, "")
          |
          |#{klass}[#{object.inspect}]
          |
          |  expected: #{object.inspect}
          |       got: #{begin; checkup; rescue => err; err.inspect; end}
        REPORT
    else
      expect { checkup }
        .to raise_error(Assertion::InvalidError), <<-REPORT.gsub(/.+\|/, "")
          |
          |#{klass}[#{object.inspect}]
          |
          |  expected: #<Assertion::InvalidError>
          |       got: #{object.inspect}
        REPORT
    end
  end

  it "[raises expected message]" do
    begin
      checkup if !result && errors
    rescue => err
      expect(err.messages)
        .to match_array(errors), <<-REPORT.gsub(/.+\|/, "")
          |
          |Language: #{locale.to_s.upcase}
          |Error messages from #{klass}[#{object.inspect}]
          |
          |  expected: #{errors.inspect}
          |       got: #{err.messages.inspect}
        REPORT
    end
  end

end # shared examples
