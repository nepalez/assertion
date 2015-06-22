# encoding: utf-8

module Assertion

  # The base class for assertions about some attributes
  #
  # Every assertion should define a list of attributes to be checked and
  # the [#check] method to apply the assertion to those attributes
  #
  # The assertion `call` method provides the object, describing the state
  # of the assertion applied to its attributes. The provided state carries
  # the result of the checkup and a corresponding <error> message.
  # Later it can be composed with other states to provide complex validation.
  #
  # The class DSL also defines shortcuts:
  #
  # * [.[]] can be used to initialize the assertion for given attributes and
  #   then apply it immediately with creation of the corresponding state.
  # * [.not] can be used to provide the assertion opposite to the initial one.
  #
  # @example
  #   class Adult < Assertion::Base
  #     attribute :name, :age
  #
  #     def check
  #       age >= 18
  #     end
  #   end
  #
  #   child = Adult.not
  #
  #   jane = { name: "Jane", age: 12 }
  #   Adult[jane].valid? # => false
  #   child[jane].valid? # => true
  #
  class Base

    extend BaseDSL

    # The translator of states for the current class
    #
    # @return [Assertion::Translator]
    #
    def self.translator
      @translator ||= Translator.new(self)
    end

    # @!attribute [r] attributes
    #
    # @example
    #   Adult = Assertion.about :name, :age do
    #     age >= 18
    #   end
    #
    #   adult = Adult[name: "Joe", age: 15, gender: :male]
    #   adult.attributes # => { name: "Joe", age: 15 }
    #
    # @return [Hash]
    #   The hash of the allowed attributes having been initialized
    #
    attr_reader :attributes

    # @!scope class
    # @!method new(args = {})
    # Initializes an assertion for the current object
    #
    # @param [Hash] args The arguments to check
    #
    # @return [Assertion::Base]

    # @private
    def initialize(args = {})
      keys = self.class.attributes
      @attributes = Hash[keys.zip(args.values_at(*keys))]
      freeze
    end

    # Returns the message describing the current state
    #
    # @param [Boolean] state The state to describe
    #
    # @return [String]
    #
    def message(state)
      self.class.translator.call(state, attributes)
    end

    # Calls the assertion checkup and returns the resulting state
    #
    # The state is a unified composable object, unaware of the
    # structure and attributes of the specific assertion.
    #
    # @return [Assertion::State]
    #   The state of the assertion being applied to its attributes
    #
    def call
      State.new check, message(false)
    end

  end # class Base

end # module Assertion
