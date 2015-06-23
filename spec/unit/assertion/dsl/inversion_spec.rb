# encoding: utf-8

describe Assertion::DSL::Inversion do

  let(:klass) { Class.new { extend Assertion::DSL::Inversion } }

  describe "#not" do

    subject { klass.not }

    it "creates the iverter for the current class" do
      expect(subject).to be_kind_of Assertion::Inverter
      expect(subject.source).to eql klass
    end

  end # describe .not

end # describe Assertion::DSL::Inversion
