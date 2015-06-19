# encoding: utf-8

module Assertion

  # Describes the state of the assertion applied to given arguments
  # (the result of the checkup)
  #
  # @api public
  #
  class State

    # @!scope class
    # @!method new(state, *messages)
    # Creates the immutable state instance with a corresponding error messages
    #
    # @param [Boolean] state
    # @param [String, Array<String>] messages
    #
    # @return [Assertion::State]

    # @private
    def initialize(state, *messages)
      @state = state
      @messages = (state ? [] : messages.flatten.uniq).freeze
      freeze
    end

    # @!attribute [r] messages
    #
    # @return [Array<String>] error messages
    #
    attr_reader :messages

    # Check whether a stated assertion is satisfied by its attributes
    #
    # @return [Boolean]
    #
    def valid?
      !invalid?
    end

    # Check whether a stated assertion is not satisfied by its attributes
    #
    # @return [Boolean]
    #
    def invalid?
      !@state
    end

    # Check whether a stated assertion is satisfied by its attributes
    #
    # @return [true]
    #
    # @raise [Assertion::InvalidError]
    #   When an assertion is not satisfied (validation fails)
    #
    def validate!
      invalid? ? fail(InvalidError.new messages) : true
    end

    # Composes the state with the other state
    #
    # @param [Assertion::State] other
    #
    # @return [Assertion::State]
    #   The composed state that carries messages from both the states
    #
    # @alias >>
    # @alias +
    #
    def &(other)
      self.class.new(valid? & other.valid?, messages + other.messages)
    end
    alias_method :>>, :&
    alias_method :+, :&

  end # class State

end # module Assertion
