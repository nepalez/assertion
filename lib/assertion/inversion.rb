# encoding: utf-8

module Assertion

  # Describes the inversion of the assertion object
  #
  # The inversion decorates the source assertion switching its message
  # (from falsey to truthy) and reverting its `check`.
  #
  # @example
  #   IsAdult = Assertion.about :name, :age do
  #     age >= 18
  #   end
  #
  #   assertion = IsAdult.new
  #   inversion = Inversion.new(assertion)
  #
  #   assertion.call.valid? == inversion.call.invalid? # => true
  #
  # @api private
  #
  class Inversion < Base

    # @!scope class
    # @!method new(assertion)
    # Creates the inversion for the selected assertion object
    #
    # @param [Assertion::Base] assertion The assertion being inverted
    #
    # @return [Assertion::Inversion]

    # @private
    def initialize(assertion)
      @assertion = assertion
      freeze
    end

    # @!attribute [r] assertion
    #
    # @return [Assertion::Base] The assertion being inverted
    #
    attr_reader :assertion

    # The translated message describing the state of assertion
    #
    # @param [Boolean] state
    #
    # @return [String]
    #
    def message(state = nil)
      assertion.message !state
    end

    # Checks the current state of the assertion
    #
    # @return [Boolean]
    #
    def check
      !assertion.check
    end

  end # class Inversion

end # module Assertion
