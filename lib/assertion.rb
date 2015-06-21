# encoding: utf-8

require "transproc"

require_relative "assertion/transprocs/inflector"
require_relative "assertion/transprocs/list"

require_relative "assertion/invalid_error"
require_relative "assertion/attributes"
require_relative "assertion/messages"

require_relative "assertion/state"
require_relative "assertion/base"
require_relative "assertion/inversion"
require_relative "assertion/inverter"
require_relative "assertion/guard"

# The module allows declaring assertions (assertions) about various objects,
# and apply (validate) them to concrete data.
#
# @example
#   # config/locales/en.yml
#   # ---
#   # en:
#   #   assertion:
#   #     is_adult:
#   #       truthy: "%{name} is an adult (age %{age})"
#   #       falsey: "%{name} is a child (age %{age})"
#
#   IsAdult = Assertion.about :name, :age do
#     age >= 18
#   end
#
#   joe = { name: 'Joe', age: 13 }
#   IsAdult[joe].validate!
#   # => #<Assertion::InvalidError @messages=["Joe is a child (age 13)"]>
#
#   jane = { name: 'Jane', age: 22 }
#   IsAdult.not[jane].validate!
#   # => #<Assertion::InvalidError @messages=["Jane is an adult (age 22)"]
#
# @api public
#
module Assertion

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
  def self.about(*attributes, &block)
    klass = Class.new(Base)
    klass.public_send(:attribute, attributes)
    klass.__send__(:define_method, :check, &block) if block_given?

    klass
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
  def self.guards(attribute = nil, &block)
    klass = Class.new(Guard)
    klass.public_send(:attribute, attribute) if attribute
    klass.__send__(:define_method, :state, &block) if block_given?

    klass
  end

end # module Assertion
