# encoding: utf-8

require "i18n"

module Assertion

  # Module defines how to translate messages describing the desired state
  # of the current assertion
  #
  # You need to declare a hash of attributes to be added to the translation.
  #
  # @example
  #   class MyClass
  #     include Assertion::Translator
  #     def attributes
  #       {}
  #     end
  #   end
  #
  #   item = MyClass.new
  #   item.message(true)
  #   # => "translation missing: en.assertion.my_class.truthy"
  #   item.message(false)
  #   # => "translation missing: en.assertion.my_class.falsey"
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  class Translator

    # The gem-specific root scope for translations
    #
    # @return [Symbol]
    #
    ROOT = :assertion

    # @!attribute [r] scope
    #
    # @return [Array<Symbol>] the scope for translations
    #
    attr_reader :scope

    # @!attribute [r] scope
    #
    # @return [Class] the assertion whose state should be translated
    #
    attr_reader :assertion

    # @!scope class
    # @!method new(assertion)
    # Creates a state translator for the given assertion class
    #
    # @param [Class] assertion
    #
    # @return [Assertion::Translator]

    # @private
    def initialize(assertion)
      @assertion = assertion
      @scope = "#{ROOT}.#{Inflecto.underscore assertion}"
      IceNine.deep_freeze(self)
    end

    # Returns the message describing the desired state of given assertion
    #
    # The translation is provided in a gem-specific scope for the current class
    #
    # @param [Boolean] state The state of the assertion
    # @param [Hash] args The hash of arguments to be avaliable in a translation
    #
    # @return [String] The translation
    #
    def call(state, args = {})
      I18n.translate state, args.merge(scope: scope)
    end

  end # class Translator

end # module Assertion
