module Assertion

  # The collection of pure functions for converting constants
  # to corresponding path names.
  #
  # @api private
  #
  module Inflector

    extend ::Transproc::Registry

    # @private
    def to_snake(name)
      name.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/_+/, "_").downcase
    end

    # @private
    def to_path(name)
      name.split(%r{\:\:|-|/}).reject(&:empty?).join("/")
    end

    # Converts the name of the constant to the corresponding path
    #
    # @example
    #   fn = Inflector[:to_snake_path]
    #   fn["::Foo::BarBaz"]
    #   # => "foo/bar_baz"
    #
    # @param [String] name The name of the constant
    #
    # @return [String] The path
    #
    def to_snake_path(name)
      to_path(to_snake(name))
    end

  end # module Inflector

end # module Assertion
