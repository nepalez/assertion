module Assertion

  # Provides methods to describe and apply guards
  #
  module GuardDSL

    include DSL::Caller

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
