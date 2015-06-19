# encoding: utf-8

module Assertion

  # Module Attributes provides features to define and store a list of attributes
  # shared by the [Assertion::Base] and [Assertion::Guard] classes
  #
  module Attributes

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
    # @raise [NameError]
    #   When the name is either used by instance attribute,
    #   or forbidden as a name of the method to be implemented later
    #   (not as an attribute)
    #
    def attribute(*names)
      @attributes = List[:symbolize][attributes + names]
      __check_attributes__
    end

    private

    # Names of the methods that should be reserved to be used later
    #
    # @return [Array<Symbol>]
    #
    # @abstract
    #
    def __forbidden_attributes__
      []
    end

    def __check_attributes__
      names = attributes & (instance_methods + __forbidden_attributes__)
      return if names.empty?
      fail NameError.new "Wrong name(s) for attribute(s): #{names.join(", ")}"
    end

  end # module Attributes

end # module Assertion
