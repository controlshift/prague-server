require 'spec_helper'

shared_examples_for "live mode" do
  describe 'scope' do
    it 'should respond to live scope' do
      expect(described_class).to respond_to(:live)
    end

    it 'should respond to test scope' do
     expect(described_class).to respond_to(:test)
    end
  end

  describe 'booleans' do
    it 'should be live by default' do
      inst = described_class.new
      expect(inst.live?).to be_truthy
      expect(inst.test?).to be_falsey
    end
  end
end