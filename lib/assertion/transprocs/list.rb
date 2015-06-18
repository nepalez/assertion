module Assertion

  # The collection of pure functions for converting arrays
  #
  # @api private
  #
  module List

    extend ::Transproc::Registry

    # Converts the nested array of strings and symbols into the flat
    # array of unique symbols
    #
    # @example
    #   fn = List[:symbolize]
    #   source = [:foo, ["foo", "bar"], :bar, "baz"]
    #   fn[source]
    #   # => [:foo, :bar, :baz]
    #
    # @param [Array<String, Symbol, Array>] array
    #
    # @return [Array<Symbol>]
    #
    def symbolize(array)
      array.flatten.map(&:to_sym).uniq
    end

  end # module List

end # module Assertion
