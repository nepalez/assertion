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

end # module Assertion
