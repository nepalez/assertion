# encoding: utf-8

module Assertion

  # The base class for object guards
  #
  # The guard defines a desired state for the object and checks
  # if that state is valid.
  #
  # Its `call` method either returns the guarded object, or
  # (when its state is invalid) raises an exception
  #
  # The class DSL also defines a `.[]` shortcut to initialize
  # and call the guard for given object immediately.
  #
  # @example
  #   class AdultOnly < Assertion::Guard
  #     alias_method :user, :object
  #
  #     def state
  #       IsAdult[user.attributes]
  #     end
  #   end
  #
  #   jack = User.new name: "Jack", age: 10
  #   john = User.new name: "John", age: 59
  #
  #   AdultOnly[jack]
  #   # => #<Assertion::InvalidError @messages=["Jack is a child (age 10)"]>
  #   AdultOnly[john]
  #   # => #<User @name="John", @age=59>
  #
  class Guard

    extend GuardDSL

    # @!scope class
    # @!method new(object)
    # Creates the guard instance for the provided object
    #
    # @param [Object] object
    #
    # @return [Assertion::Guard]

    # @private
    def initialize(object)
      @object = object
      freeze
    end

    # Validates the state of the [#object] and returns valid object back
    #
    # @return (see #object)
    #
    # @raise [Assertion::InvalidError] if the [#object] is invalid
    #
    def call
      state.validate!
      object
    end

  end # class Guard

end # module Assertion
