require 'spec_helper'

describe Adapters::Base do
  describe "#formatted_zip" do
    let(:charge) { double }
    let(:customer) { double }
    
    before(:each) do
      charge.stub(:customer).and_return(customer)
      subject.stub(:charge).and_return(charge)
    end

    context "no country" do
      before(:each) do
        customer.stub(:country).and_return(nil)
      end

      specify do
        customer.stub(:zip).and_return('12345-')
        subject.formatted_zip.should == '12345'
      end

      specify do
        customer.stub(:zip).and_return('12345-')
        subject.formatted_zip.should == '12345'
      end

      specify do
        customer.stub(:zip).and_return('12345 -1234')
        subject.formatted_zip.should == '12345-1234'
      end

      specify do
        customer.stub(:zip).and_return('123451234')
        subject.formatted_zip.should == '12345-1234'
      end

      specify do
        customer.stub(:zip).and_return('12345 1234')
        subject.formatted_zip.should == '12345-1234'
      end

      specify do
        customer.stub(:zip).and_return('12345-1234')
        subject.formatted_zip.should == '12345-1234'
      end
      specify do
        customer.stub(:zip).and_return('02052')
        subject.formatted_zip.should ==  '02052'
      end
      specify do
        customer.stub(:zip).and_return('12345 1234')
        subject.formatted_zip.should == '12345-1234'
      end
      specify do
        customer.stub(:zip).and_return('1 2 3 4')
        subject.formatted_zip.should == '1 2 3 4'
      end
    end
    
    context 'a country' do
      before(:each) do
        customer.stub(:country).and_return('AU')
      end

      specify do
        customer.stub(:zip).and_return('1 2 3 4')
        subject.formatted_zip.should == '1234'
      end 

      it "should return the postcode if it can not be formatted" do
        customer.stub(:zip).and_return('11238-1234')
        subject.formatted_zip.should == '11238-1234'
      end
    end
  end  
end