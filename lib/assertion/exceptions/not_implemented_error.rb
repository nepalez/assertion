# encoding: utf-8

module Assertion

  # The exception to be raised when a assertion is applied to some data
  # before its `check` method has been implemented
  #
  # @api public
  #
  class NotImplementedError < ::NotImplementedError

    # @!scope class
    # @!method new(klass, name)
    # Creates an exception instance
    #
    # @param [Class] klass The class that should implement the instance method
    # @param [Symbol] name The name of the method to be implemented
    #
    # @return [Assertion::NotImplementedError]

    # @private
    def initialize(klass, name)
      super "#{klass.name}##{name} method not implemented"
      freeze
    end

  end # class NotImplementedError

end # module Assertion
