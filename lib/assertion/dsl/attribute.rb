# encoding: utf-8

module Assertion

  # Collection of DSLs for various modules and classes
  #
  module DSL

    # Allows adding aliases to `#object` method.
    #
    module Attribute

      # Adds alias to the [#object] method
      #
      # @param [#to_sym] name
      #
      # @return [undefined]
      #
      # @raise [NameError]
      #   When a given name is either used by instance methods,
      #   or reserved by the `#state` method to be implemented later.
      #
      def attribute(name)
        __check_attribute__(name)
        alias_method name, :object
      end

      private

      # Ensures the `#object` is defined
      #
      # @param [Class] klass
      #
      # @return [undefined]
      #
      def self.extended(klass)
        klass.__send__ :attr_reader, :object
      end

      # Checks if alias name for `#object` is free
      #
      # @param [#to_sym] key
      #
      # @return [undefined]
      #
      # @raise [NameError] if the key is already in use
      #
      def __check_attribute__(key)
        return unless (instance_methods << :state).include? key.to_sym
        fail NameError.new "#{self}##{key} is already defined"
      end

    end # module Attribute

  end # module DSL

end # module Assertion
