require 'spec_helper'

describe Queries::Export do

  subject { Queries::Export.new }

  context "stubbed sql" do
    before(:each) do
      subject.stub(:sql).and_return("SELECT * FROM charges WHERE 1 = 1")
      subject.stub(:klass).and_return(Charge)
    end

    it "should append a limit and offset" do
      subject.sql_for_batch(100, 20).should == "SELECT * FROM charges WHERE 1 = 1 AND charges.id > 20 ORDER BY charges.id LIMIT 100"
    end

    it "should return back the total count of rows" do
      subject.total_rows.should == 0
    end
  end
end