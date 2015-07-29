# encoding: utf-8

module Assertion

  module DSL

    # Allows to provide inverter for objects of the current class
    #
    module Inversion

      # Initializes the intermediate inverter with `new` and `[]` methods
      #
      # The inverter can be used to initialize the assertion, that describes
      # just the opposite statement to the current one
      #
      # @example
      #   IsAdult = Assertion.about :name, :age do
      #     age >= 18
      #   end
      #
      #   joe = { name: 'Joe', age: 19 }
      #
      #   IsAdult[joe].valid?     # => true
      #   IsAdult.not[joe].valid? # => false
      #
      # @return [Assertion::Inverter]
      #
      def not
        Inverter.new(self)
      end
      alias_method :!, :not

    end # module Inversion

  end # module DSL

end # module Assertion
