require 'spec_helper'

describe Queries::ChargesForOrganizationExport do
  let(:organization) { create(:organization) }

  subject { Queries::ChargesForOrganizationExport.new organization: organization }

  describe 'initialization' do
    specify { subject.organization.should == organization }
  end

  describe 'exporting' do
    let!(:charge) { create(:charge, organization: organization, config: {'foo' => 'bar'}) }
    let!(:tag) { create(:tag, name: 'whales', organization: organization) }
    let!(:namespace) { create(:tag_namespace, namespace: 'food', organization: organization)}
    let!(:namespaced_tag) { create(:tag, name: 'food:cookies', organization: organization, namespace: namespace) }

    before :each do
      charge.tags << tag
      charge.tags << namespaced_tag
    end

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
          specify{ header.should include("last_name") }
          specify{ header.should include("email")}
          specify{ header.should include("amount")}
          specify{ header.should include("currency")}
          specify{ header.should include("config")}
          specify{ header.should include("status")}
          specify{ header.should include("created_at")}
          specify{ header.should include("tags")}
        end

        describe "first row" do
          let(:first_row) { @parsed[1] }

          specify{ first_row.should include(charge.customer.first_name)}
          specify{ first_row.should include(charge.customer.last_name)}
          specify{ first_row.should include(charge.customer.email)}
          specify{ first_row.should include(charge.amount.to_s) }
          specify{ first_row.should include(charge.currency) }
          specify{ first_row.should include('"foo"=>"bar"')}
          specify{ first_row.should include('live') }
          specify{ first_row.should include(charge.created_at.strftime("%F %H:%M:%S.%6N")) }
          specify{ first_row.should include('whales,food:cookies') }
        end
      end
    end
  end
end
