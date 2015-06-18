# encoding: utf-8

require "transproc"
require "i18n"

require_relative "assertion/transprocs/inflector"
require_relative "assertion/transprocs/i18n"
require_relative "assertion/transprocs/list"

require_relative "assertion/exceptions/name_error"
require_relative "assertion/exceptions/not_implemented_error"
require_relative "assertion/exceptions/invalid_error"

require_relative "assertion/state"
require_relative "assertion/base"
require_relative "assertion/inversion"
require_relative "assertion/inverter"

# The module allows declaring assertions (assertions) about various objects,
# and apply (validate) them to concrete data.
#
# @example
#   # config/locales/en.yml
#   # ---
#   # en:
#   #   assertion:
#   #     adult:
#   #       right: "%{name} is an adult (age %{age})"
#   #       wrong: "%{name} is a child (age %{age})"
#
#   Adult = Assertion.about :name, :age do
#     age >= 18
#   end
#
#   joe = { name: 'Joe', age: 13 }
#   Adult[joe].validate!
#   # => #<Assertion::InvalidError @messages=["Joe is a child (age 13)"]>
#
#   jane = { name: 'Jane', age: 22 }
#   Adult.not[jane].validate!
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
  # @return [Assertion::Base]
  #
  def self.about(*attributes, &block)
    klass = Class.new(Base)
    klass.public_send(:attribute, attributes)
    klass.__send__(:define_method, :check, &block) if block_given?

    klass
  end

end # module Assertion
