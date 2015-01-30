require 'spec_helper'

describe Queries::Export do

  subject { Queries::Export.new }

  context "stubbed sql" do
    before(:each) do
      allow(subject).to receive(:sql).and_return("SELECT * FROM charges WHERE 1 = 1")
      allow(subject).to receive(:klass).and_return(Charge)
    end

    it "should append a limit and offset" do
      expect(subject.sql_for_batch(100, 20)).to eq "SELECT * FROM charges WHERE 1 = 1 AND charges.id > 20 ORDER BY charges.id LIMIT 100"
    end

    it "should return back the total count of rows" do
      expect(subject.total_rows).to eq 0
    end
  end
end