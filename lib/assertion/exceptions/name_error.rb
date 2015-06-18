# encoding: utf-8

module Assertion

  # The exception to be raised when a Assertion attribute uses reserved name(s)
  #
  # @api public
  #
  class NameError < ::NameError

    # @!scope class
    # @!method new(*names)
    # Creates an exception instance
    #
    # @param [Symbol, Array<Symbol>] names Wrong names of attribute(s)
    #
    # @return [Assertion::NameError]
    #
    # @api private

    # @private
    def initialize(*names)
      super "Wrong name(s) for attribute(s): #{names.join(", ")}"
      freeze
    end

  end # class NameError

end # module Assertion
