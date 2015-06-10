require 'spec_helper'

describe Adapters::ActionKit::Action do
  describe '#config_hash' do
    let(:charge) { build(:charge, config: {'action_foo' => 'bar', 'a' => 'b', 'akid' => 'XXX'}) }
    subject { Adapters::ActionKit::Action.new charge: charge  }

    it 'should only return the key value pairs where the key starts with action_' do
      expect(subject.send(:config_hash)).to eq({'action_foo' => 'bar', 'orig_akid' => 'XXX'})
    end
  end
end