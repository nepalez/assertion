# encoding: utf-8

require "ostruct"

describe Assertion::DSL::Caller do

  let(:klass) do
    Class.new(OpenStruct) do
      extend Assertion::DSL::Caller
      alias_method :call, :inspect
    end
  end

  describe "#[]" do

    it "works" do
      args = { foo: :FOO, baz: :BAZ }
      expect(klass[args]).to eql klass.new(args).call
    end

  end # describe #[]

end # describe Assertion::DSL::Caller
