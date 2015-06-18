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
  #   jane = { name: "Jane", age: 12 }
  #   Adult[jane].valid? # => false
  #
  class Base

    # Class DSL
    #
    class << self

      # List of attributes, defined for the class
      #
      # @return [Array<Symbol>]
      #
      def attributes
        @attributes ||= []
      end

      # Adds a new attribute or a list of attributes to the class
      #
      # @param [Symbol, Array<Symbol>] names
      #
      # @return [undefined]
      #
      # @raise [Assertion::NameError]
      #   When the name is already used by instance attribute
      #
      def attribute(*names)
        @attributes = List[:symbolize][attributes + names]
        __check__
      end

      # Initializes a assertion with some attributes (data) and then calls it
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

      private

      # Checks if all the attributes have valid names
      def __check__
        wrong = attributes & instance_methods
        fail(NameError.new wrong) if wrong.any?
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

    # Returns the translated message about the current state of the assertion
    # applied to its attributes
    #
    # @param [Symbol] state The state to be described
    #
    # @return [String] The message
    #
    def message(state = nil)
      I18n[:translate, __scope__, attributes][state ? :right : :wrong]
    end

    # Checks whether the assertion is right for the current attributes
    #
    # @return [Boolean]
    #
    # @raise [Check::NotImplementedError]
    #   When the [#check] method hasn't been implemented
    #
    def check
      fail NotImplementedError.new(self.class, :check)
    end

    # Calls the assertion checkup and returns the state of the assertion having
    # been applied to the current attributes
    #
    # @return [Check::State]
    #   The state of the assertion being applied to its attributes
    #
    def call
      state = check
      State.new state, message
    end

    private

    # The scope for translating messages using the `I18n` module
    #
    # @return [Array<Symbol>]
    #
    def __scope__
      I18n[:scope][self.class.name]
    end

    # Defines the object attribute and assigns given value to it
    #
    # @param [Symbol] name The name of the attribute
    # @param [Object] value The value of the attribute
    #
    # @return [undefined]
    #
    def __set_attribute__(name, value)
      attributes[name] = value
      singleton_class.__send__(:define_method, name) { value }
    end

  end # class Base

end # module Assertion
