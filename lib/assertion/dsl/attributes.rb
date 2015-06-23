# encoding: utf-8

module Assertion

  module DSL

    # Allows adding aliases to values of the `#attributes` hash.
    #
    module Attributes

      # List of declared attributes
      #
      # @return [Array<Symbol>]
      #
      def attributes
        @attributes ||= []
      end

      # Declares new attribute(s) by name(s)
      #
      # @param [#to_sym, Array<#to_sym>] names
      #
      # @return [undefined]
      #
      # @raise [NameError]
      #   When a given name is either used by instance methods,
      #   or reserved by the `#check` method to be implemented later.
      #
      def attribute(*names)
        names.flatten.map(&:to_sym).each(&method(:__add_attribute__))
      end

      # @private
      def self.extended(klass)
        klass.__send__(:define_method, :attributes) { @attributes ||= {} }
      end

      private

      def __add_attribute__(name)
        __check_attribute__(name)
        attributes << define_method(name) { attributes[name] }
      end

      def __check_attribute__(name)
        return unless (instance_methods << :check).include? name
        fail NameError.new "#{self}##{name} is already defined"
      end

    end # module Attributes

  end # module DSL

end # module Assertion
