require 'spec_helper'

describe Queries::ChargesForOrganizationExport do
  let(:organization) { create(:organization) }

  subject { Queries::ChargesForOrganizationExport.new organization: organization }

  describe 'initialization' do
    specify { expect(subject.organization).to eq(organization) }
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
      expect(subject.header_row).to include('first_name')
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

          specify{ expect(header).to include("first_name") }
          specify{ expect(header).to include("last_name") }
          specify{ expect(header).to include("email") }
          specify{ expect(header).to include("amount") }
          specify{ expect(header).to include("currency") }
          specify{ expect(header).to include("config") }
          specify{ expect(header).to include("status") }
          specify{ expect(header).to include("created_at") }
          specify{ expect(header).to include("tags") }
        end

        describe "first row" do
          let(:first_row) { @parsed[1] }

          specify{ expect(first_row).to include(charge.customer.first_name) }
          specify{ expect(first_row).to include(charge.customer.last_name) }
          specify{ expect(first_row).to include(charge.customer.email) }
          specify{ expect(first_row).to include(charge.amount.to_s) }
          specify{ expect(first_row).to include(charge.currency) }
          specify{ expect(first_row).to include('"foo"=>"bar"') }
          specify{ expect(first_row).to include('live') }
          specify{ expect(first_row).to include(charge.created_at.strftime("%F %H:%M:%S.%-6N")) }
          specify{ expect(first_row).to include('whales,food:cookies') }
        end

        describe 'a charge from a difference organization' do
          let!(:another_org) { create(:organization) }
          let!(:another_charge) { create(:charge, organization: another_org, config: {'foo' => 'bar'}) }

          before :each do
            another_charge.tags << tag
          end

          it 'should not be included' do
            expect(subject.total_rows).to eq(1)
          end
        end
      end
    end
  end
end
