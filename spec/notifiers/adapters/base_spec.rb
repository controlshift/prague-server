require 'spec_helper'

describe Adapters::Base do
  describe "#formatted_zip" do
    let(:charge) { double }
    let(:customer) { double }

    before(:each) do
      allow(charge).to receive(:customer).and_return(customer)
      allow(subject).to receive(:charge).and_return(charge)
    end

    context "no country" do
      before(:each) do
        allow(customer).to receive(:country).and_return(nil)
      end

      specify do
        allow(customer).to receive(:zip).and_return('12345-')
        expect(subject.formatted_zip).to eq '12345'
      end

      specify do
        allow(customer).to receive(:zip).and_return('12345-')
        expect(subject.formatted_zip).to eq '12345'
      end

      specify do
        allow(customer).to receive(:zip).and_return('12345 -1234')
        expect(subject.formatted_zip).to eq '12345-1234'
      end

      specify do
        allow(customer).to receive(:zip).and_return('123451234')
        expect(subject.formatted_zip).to eq '12345-1234'
      end

      specify do
        allow(customer).to receive(:zip).and_return('12345 1234')
        expect(subject.formatted_zip).to eq '12345-1234'
      end

      specify do
        allow(customer).to receive(:zip).and_return('12345-1234')
        expect(subject.formatted_zip).to eq '12345-1234'
      end
      specify do
        allow(customer).to receive(:zip).and_return('02052')
        expect(subject.formatted_zip).to eq  '02052'
      end
      specify do
        allow(customer).to receive(:zip).and_return('12345 1234')
        expect(subject.formatted_zip).to eq '12345-1234'
      end
      specify do
        allow(customer).to receive(:zip).and_return('1 2 3 4')
        expect(subject.formatted_zip).to eq '1 2 3 4'
      end
    end

    context 'a country' do
      before(:each) do
        allow(customer).to receive(:country).and_return('AU')
      end

      specify do
        allow(customer).to receive(:zip).and_return('1 2 3 4')
        expect(subject.formatted_zip).to eq '1234'
      end

      it "should return the postcode if it can not be formatted" do
        allow(customer).to receive(:zip).and_return('11238-1234')
        expect(subject.formatted_zip).to eq '11238-1234'
      end
    end
  end
end