require 'spec_helper'

describe Queries::ChargesForOrganizationExport do
  let(:organization) { create(:organization) }

  subject { Queries::ChargesForOrganizationExport.new organization: organization }

  describe 'initialization' do
    specify { subject.organization.should == organization }
  end

  describe 'exporting' do
    let!(:charge) { create(:charge, organization: organization, config: {'foo' => 'bar'}) }

    it 'should have a header_row' do
      subject.header_row.should include('first_name')
    end

    context 'stream as string' do
      before(:each) do
        @result = ""
        subject.as_csv_stream.each do |chunk|
          @result << chunk
        end
      end

      context "when parsed" do
        before(:each) do
          @parsed = CSV.parse(@result)
        end

        describe "header" do
          let(:header) { @parsed[0] }

          specify{ header.should include("first_name") }
          specify{ header.should include("email")}
          specify{ header.should include("config")}
        end

        describe "first row" do
          let(:first_row) { @parsed[1] }

          specify{ first_row.should include(charge.amount.to_s) }
          specify{ first_row.should include(charge.customer.email)}
          specify{ first_row.should include('"foo"=>"bar"')}
        end
      end
    end
  end
end