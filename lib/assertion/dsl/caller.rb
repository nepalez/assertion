# encoding: utf-8

module Assertion

  module DSL

    # Allows to initialize and call objects at once
    #
    module Caller

      # Initializes and immediately calls the instance of the class
      #
      # @param [Object, Array<Object>] args
      #   The <list of> arguments to initialize the instance with
      #
      # @return [Object] the result of #call method
      #
      def [](*args)
        new(*args).call
      end

    end # module Caller

  end # module DSL

end # module Assertion
