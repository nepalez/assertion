module Assertion

  # Provides methods to describe and apply guards
  #
  module GuardDSL

    # Initializes and guard for the provided object and calls it immediately
    #
    # @param [Object] object The object whose state should be tested
    #
    # @return (see Assertion::Guard#call)
    #
    # @raise (see Assertion::Guard#call)
    #
    def [](object)
      new(object).call
    end

    # Adds alias to the [#object] method
    #
    # @param [#to_sym] name
    #
    # @return [undefined]
    #
    def attribute(name)
      __check_attribute__(name)
      alias_method name, :object
    end

    private

    def __check_attribute__(key)
      return unless (instance_methods << :state).include? key.to_sym
      fail NameError.new "#{self}##{key} is already defined"
    end

  end # module GuardDSL

end # module Assertion
