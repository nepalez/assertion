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

    extend  Attributes
    include Messages

    # Class DSL
    #
    class << self

      # Initializes an assertion with some attributes (data) and then calls it
      #
      # @param [Hash] hash
      #
      # @return [Assertion::State]
      #   The object that describes the state of the assertion
      #   applied to given attributes
      #
      def [](hash = {})
        new(hash).call
      end

      # Initializes the intermediate inverter with `new` and `[]` methods
      #
      # The inverter can be used to initialize the assertion, that describes
      # just the opposite statement to the current one
      #
      # @example
      #   Adult = Assertion.about :name, :age do
      #     age >= 18
      #   end
      #
      #   joe = { name: 'Joe', age: 19 }
      #
      #   Adult[joe].valid?     # => true
      #   Adult.not[joe].valid? # => false
      #
      # @return [Assertion::Inverter]
      #
      def not
        Inverter.new(self)
      end

      private

      def __forbidden_attributes__
        [:check]
      end

    end # eigenclass

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

    # @private
    def initialize(args = {})
      @attributes = {}
      self.class.attributes.each { |name| __set_attribute__ name, args[name] }
      freeze
    end

    # Calls the assertion checkup and returns the state of the assertion having
    # been applied to the current attributes
    #
    # @return [Check::State]
    #   The state of the assertion being applied to its attributes
    #
    def call
      state = check
      State.new state, message(false)
    end

    private

    def __set_attribute__(name, value)
      attributes[name] = value
      singleton_class.__send__(:define_method, name) { value }
    end

  end # class Base

end # module Assertion
