# encoding: utf-8

require "inflecto"

require_relative "assertion/dsl/caller"
require_relative "assertion/dsl/attribute"
require_relative "assertion/dsl/attributes"
require_relative "assertion/dsl/inversion"
require_relative "assertion/dsl/builder"

require_relative "assertion/invalid_error"
require_relative "assertion/translator"
require_relative "assertion/state"
require_relative "assertion/base"
require_relative "assertion/inversion"
require_relative "assertion/inverter"
require_relative "assertion/guard"

# The module declares:
#
# * assertions about objects
# * guards (validations) for objects
#
# @example Assertion
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
#   joe = OpenStruct.new(name: 'Joe', age: 13)
#   IsAdult[joe.to_h].validate!
#   # => #<Assertion::InvalidError @messages=["Joe is a child (age 13)"]>
#
#   jane = OpenStruct.new(name: 'Jane', age: 22)
#   IsAdult.not[jane.to_h].validate!
#   # => #<Assertion::InvalidError @messages=["Jane is an adult (age 22)"]
#
# @example Guard
#   AdultOnly = Assertion.guards :user do
#     IsAdult[user.to_h]
#   end
#
#   AdultOnly[joe]
#   # => #<Assertion::InvalidError @messages=["Joe is a child (age 13)"]>
#   AdultOnly[jane]
#   # => #<OpenStruct @name="Jane", @age=22>
#
# @api public
#
module Assertion

  extend DSL::Builder

end # module Assertion
