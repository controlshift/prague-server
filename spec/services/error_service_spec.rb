require 'spec_helper'

describe ErrorService do
  let(:charge) { create(:charge, paid: true) }
  let(:exception) { Stripe::CardError.new('Lorem', {}, {}) }
  let(:error) { ErrorService.new(charge, exception, 'Test') }

  it 'returns TRUE' do
    expect(error.call).to eq(true);
  end

  it 'sets charge.paid to false' do
    error.call
    expect(charge.paid).to eq(false);
  end

  it 'creates a new log entry with correct message' do
    error.call
    expect(LogEntry.first.message).to eq('Test')
  end
end
