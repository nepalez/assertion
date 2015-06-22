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

      # List of attributes defined for the assertion
      #
      # @return [Array<Symbol>]
      #
      def attributes
        @attributes ||= []
      end

      # Declares new attribute(s) by name(s)
      #
      # @param [#to_sym, Array<#to_sym>] names
      #
      # @return [undefined]
      #
      # @raise [NameError]
      #   When an instance method with one of given names is already exist.
      #
      def attribute(*names)
        names.flatten.map(&:to_sym).each(&method(:__add_attribute__))
      end

      private

      def __add_attribute__(name)
        __check_attribute__(name)
        attributes << define_method(name) { attributes[name] }
      end

      def __check_attribute__(name)
        return unless (instance_methods << :check).include? name
        fail NameError.new "#{self}##{name} is already defined"
      end

    end # eigenclass

    include Messages

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
      keys = self.class.attributes
      @attributes = Hash[keys.zip(args.values_at(*keys))]
      freeze
    end

    # Calls the assertion checkup and returns the state of the assertion having
    # been applied to the current attributes
    #
    # @return [Check::State]
    #   The state of the assertion being applied to its attributes
    #
    def call
      State.new check, message(false)
    end

  end # class Base

end # module Assertion
