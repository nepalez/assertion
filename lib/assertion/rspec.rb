# encoding: utf-8

# ==============================================================================
# Collection of shared examples for testing assertions and guards
# ==============================================================================

shared_context :assertion_translations do

  def __locale__
    defined?(locale) ? locale : :en
  end

  # allows to skip check for error messages
  def __messages__
    defined?(messages) ? Array[*messages] : nil
  end

  around do |example|
    old, I18n.locale = I18n.locale, __locale__
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
  def __assertion__
    defined?(assertion) ? assertion : described_class
  end

  # allows to skip `valid` definition to test messages only
  def __valid__
    defined?(valid) ? valid : false
  end

  subject(:state) { __assertion__[attributes] }

  include_context :assertion_translations

  it "[validates]" do
    expect(state.valid?).to eql(__valid__), <<-REPORT.gsub(/.+\|/, "")
      |
      |#{__assertion__}[#{attributes.to_s[1..-2]}]
      |
      |  expected: to be #{__valid__ ? "valid" : "invalid"}
      |       got: #{state.valid? ? "valid" : "invalid"}
    REPORT
  end

  it "[raises expected message]" do
    if !__valid__ && state.invalid? && __messages__
      expect(state.messages)
        .to match_array(__messages__), <<-REPORT.gsub(/.+\|/, "")
          |
          |Language: #{__locale__.to_s.upcase}
          |Error messages from #{__assertion__}[#{attributes.to_s[1..-2]}]
          |
          |  expected: #{__messages__.inspect}
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
  def __guard__
    defined?(guard) ? guard : described_class
  end

  # allows to skip `valid` definition to test messages only
  def __accepted__
    defined?(accepted) ? accepted : false
  end

  subject(:checkup) { guard[object] }

  include_context :assertion_translations

  it "[guards]" do
    if __accepted__
      expect { checkup }
        .not_to raise_error, <<-REPORT.gsub(/.+\|/, "")
          |
          |#{__guard__}[#{object.inspect}]
          |
          |  expected: #{object.inspect}
          |       got: #{begin; checkup; rescue => err; err.inspect; end}
        REPORT
    else
      expect { checkup }
        .to raise_error(Assertion::InvalidError), <<-REPORT.gsub(/.+\|/, "")
          |
          |#{__guard__}[#{object.inspect}]
          |
          |  expected: #<Assertion::InvalidError>
          |       got: #{object.inspect}
        REPORT
    end
  end

  it "[raises expected message]" do
    begin
      checkup if !__accepted__ && __messages__
    rescue => err
      expect(err.messages)
        .to match_array(__messages__), <<-REPORT.gsub(/.+\|/, "")
          |
          |Language: #{__locale__.to_s.upcase}
          |Error messages from #{__guard__}[#{object.inspect}]
          |
          |  expected: #{__messages__.inspect}
          |       got: #{err.messages.inspect}
        REPORT
    end
  end

end # shared examples
