# encoding: utf-8

require "i18n"

module Assertion

  # Module Messages provides a feature for gem-specific translation of messages
  # describing the desired state of the assertion
  #
  # You need to declare a hash of attributes to be added to the translation.
  #
  # @example
  #   class MyClass
  #     include Assertion::Messages
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
  module Messages

    # The gem-specific root scope for translations
    #
    # @return [Symbol]
    #
    ROOT = :assertion

    # The states to be translated with their dictionary names
    #
    # @return [Hash<Object => Symbol>]
    #
    DICTIONARY = { true => :truthy, false => :falsey }

    # Returns the message describing the desired state of assertion
    #
    # The translation is provided for the gem-specific scope for the
    # current class
    #
    # @param [Boolean] state <description>
    #
    # @return [String] The translation
    #
    def message(state)
      key   = DICTIONARY[state]
      scope = [ROOT, Inflector[:to_snake_path][self.class.name]]

      I18n.translate key, attributes.merge(scope: scope)
    end

    # @private
    def attributes
      {}
    end

  end # module Messages

end # module Assertion
