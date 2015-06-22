# encoding: utf-8

module Assertion

  # Provides methods to describe and apply assertions
  #
  module BaseDSL

    # Initializes an assertion with some attributes (data) and then calls it
    #
    # @param (see Assertion::Base.new)
    #
    # @return (see Assertion::Base#call)
    #
    def [](args = nil)
      new(args).call
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

  end # module BaseDSL

end # module Assertion
