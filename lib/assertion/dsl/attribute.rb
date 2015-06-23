# encoding: utf-8

module Assertion

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

      # @private
      def self.extended(klass)
        klass.__send__ :attr_reader, :object
      end

      private

      def __check_attribute__(key)
        return unless (instance_methods << :state).include? key.to_sym
        fail NameError.new "#{self}##{key} is already defined"
      end

    end # module Attribute

  end # module DSL

end # module Assertion
