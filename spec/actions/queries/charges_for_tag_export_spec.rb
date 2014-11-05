require 'spec_helper'

describe Queries::ChargesForTagExport do
  let(:organization) { create(:organization) }
  let(:tag) { create(:tag, name: 'foo', organization: organization) }

  subject { Queries::ChargesForTagExport.new tag: tag }

  describe 'initialization' do
    specify { expect(subject.tag).to eq(tag) }
  end

  describe 'exporting' do
    let!(:charge) { create(:charge, organization: organization, config: {'foo' => 'bar'}) }

    before :each do
      charge.tags << tag
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
          specify{ expect(first_row).to include(charge.created_at.strftime("%F %H:%M:%S.%6N")) }
          specify{ expect(first_row).to include('foo') }
        end
      end
    end
  end
end
