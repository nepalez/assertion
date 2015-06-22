# encoding: utf-8

module Assertion

  # Provides methods to build assertions and guards
  #
  module DSL

    # Builds the subclass of `Assertion::Base` with predefined `attributes`
    # and implementation of the `#check` method.
    #
    # @example
    #   IsMan = Assertion.about :age, :gender do
    #     (age >= 18) && (gender == :male)
    #   end
    #
    #   # This is the same as:
    #   class IsMan < Assertion::Base
    #     attribute :age, :gender
    #
    #     def check
    #       (age >= 18) && (gender == :male)
    #     end
    #   end
    #
    # @param [Symbol, Array<Symbol>] attributes
    #   The list of attributes for the new assertion
    # @param [Proc] block
    #   The content for the `check` method
    #
    # @return [Class] The specific assertion class
    #
    def about(*attributes, &block)
      __build__(Base, attributes, :check, &block)
    end

    # Builds the subclass of `Assertion::Guard` with given attribute
    # (alias for the `object`) and implementation of the `#state` method.
    #
    # @example
    #   VoterOnly = Assertion.guards :user do
    #     IsAdult[user.attributes] & IsCitizen[user.attributes]
    #   end
    #
    #   # This is the same as:
    #   class VoterOnly < Assertion::Guard
    #     alias_method :user, :object
    #
    #     def state
    #       IsAdult[user.attributes] & IsCitizen[user.attributes]
    #     end
    #   end
    #
    # @param [Symbol] attribute
    #   The alias for the `object` attribute
    # @param [Proc] block
    #   The content for the `state` method
    #
    # @return [Class] The specific guard class
    #
    def guards(attribute = nil, &block)
      __build__(Guard, attribute, :state, &block)
    end

    private

    def __build__(type, attributes, name, &block)
      klass = Class.new(type)
      klass.public_send(:attribute, attributes) if attributes
      klass.__send__(:define_method, name, &block) if block_given?

      klass
    end

  end # module DSL

end # module Assertion
