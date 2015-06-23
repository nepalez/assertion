# encoding: utf-8

module Assertion

  # Provides methods to describe and apply assertions
  #
  module BaseDSL

    include DSL::Caller
    include DSL::Attributes

    # Initializes the intermediate inverter with `new` and `[]` methods
    #
    # The inverter can be used to initialize the assertion, that describes
    # just the opposite statement to the current one
    #
    # @example
    #   IsAdult = Assertion.about :name, :age do
    #     age >= 18
    #   end
    #
    #   joe = { name: 'Joe', age: 19 }
    #
    #   IsAdult[joe].valid?     # => true
    #   IsAdult.not[joe].valid? # => false
    #
    # @return [Assertion::Inverter]
    #
    def not
      Inverter.new(self)
    end

  end # module BaseDSL

end # module Assertion
