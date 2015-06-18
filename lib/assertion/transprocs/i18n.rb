module Assertion

  # The collection of pure functions for translating strings in the gem-specific
  # scopes of `Assertion::Base` subclasses.
  #
  # @api private
  #
  module I18n

    extend ::Transproc::Registry

    uses :to_snake_path, from: Inflector, as: :snake

    # Converts the name of the class to the corresponding gem-specific scope
    #
    # @example
    #   fn = I18n[:scope]
    #   fn["Foo::BarBaz"]
    #   # => [:assertion, :"foo/bar_baz"]
    #
    # @param [String] name The name of the class
    #
    # @return [Array<Symbol>] The `I18n`-compatible gem-specific scope
    #
    def scope(name)
      [:assertion, snake(name).to_sym]
    end

    # Translates the key with hash of attributes in a given scope
    #
    # @example
    #   # config/locales/en.yml
    #   # ---
    #   # en:
    #   #   assertion:
    #   #     foo:
    #   #       qux: "message %{bar}"
    #
    #   fn = I18n[:translate, [:assertion, :foo], bar: :BAZ]
    #   fn[:qux]
    #   # => "message BAZ"
    #
    # @param [key] key The key to be translated
    # @param [Array<Symbol>] scope The I18n scope for the translations
    # @param [Hash] hash The hash of attributes for the translation
    #
    # @return [String] The translated string
    #
    def translate(key, scope, hash)
      ::I18n.t(key, hash.merge(scope: scope))
    end

  end # module I18n

end # module Assertion
