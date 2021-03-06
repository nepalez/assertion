# encoding: utf-8

module Assertion

  # The exception to be raised by invalid assertions' `validate!` method call
  #
  # @api public
  #
  class InvalidError < RuntimeError

    # @!scope class
    # @!method new(*names)
    # Creates an exception instance
    #
    # @param [Symbol, Array<Symbol>] names Wrong names of attribute(s)
    #
    # @return [Assertion::InvalidError]
    #
    # @api private

    # @private
    def initialize(*messages)
      @messages = messages.flatten
      IceNine.deep_freeze(self)
    end

    # @!attribute [r] messages
    #
    # @return [Array<String>] The list of error messages
    #
    attr_reader :messages

    # @private
    def inspect
      "<#{self} @messages=#{messages}>"
    end

  end # class InvalidError

end # module Assertion
