require 'spec_helper'

shared_examples_for "live mode" do
  describe 'scope' do
    it 'should respond to live scope' do
      described_class.should respond_to(:live)
    end

    it 'should respond to test scope' do
     described_class.should respond_to(:test)
    end
  end

  describe 'booleans' do
    it 'should be live by default' do
      inst = described_class.new
      inst.live?.should be_true
      inst.test?.should be_false
    end
  end
end