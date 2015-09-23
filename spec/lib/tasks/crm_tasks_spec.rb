require 'spec_helper'
require 'rake'

describe 'crm tasks' do
  describe 'crm:resync_charges' do
    let(:crm) { build_stubbed(:crm) }
    let(:organization) { build_stubbed(:organization, slug: 'my_organization', crm: crm) }
    let(:organization_slug) { 'my_organization' }

    before :all do
      Rake.application.rake_require "tasks/crm_tasks"
      Rake::Task.define_task(:environment)
    end

    before :each do
      Rake::Task['crm:resync_charges'].reenable
      ENV.delete('ORGANIZATION_SLUG')
      ENV.delete('FROM_DATE')

      allow(Organization).to receive(:find_by_slug).with(organization_slug).and_return(organization)
    end

    it "should raise error if missing ORGANIZATION_SLUG parameter" do
      expect { Rake.application.invoke_task 'crm:resync_charges' }.to raise_error(ArgumentError, /ORGANIZATION_SLUG/)
    end

    it "should raise error if organisation not found" do
      ENV['ORGANIZATION_SLUG'] = 'inexistent_organization'

      expect { Rake.application.invoke_task 'crm:resync_charges' }.to raise_error(/inexistent_organization/)
    end

    it "should raise error if FROM_DATE parameter is not a valid date" do
      ENV['ORGANIZATION_SLUG'] = organization_slug
      ENV['FROM_DATE'] = 'not a valid date'

      expect { Rake.application.invoke_task 'crm:resync_charges' }.to raise_error(ArgumentError, /not a valid date/)
    end

    context "Valid organization" do
      let(:charges_relation) { double }

      before :each do
        ENV['ORGANIZATION_SLUG'] = organization_slug

        expect(organization).to receive(:charges).and_return(charges_relation)
        expect(charges_relation).to receive(:paid).and_return(charges_relation)
      end

      context "CRM is BSD" do
        before :each do
          crm.platform = 'bluestate'
        end

        it "should enqueue jobs on CrmNotificationWorker for each charge" do
          allow(charges_relation).to receive(:select).with(:id).and_return([double(id: 100), double(id: 101), double(id: 102)])
          expect(CrmNotificationWorker).to receive(:perform_async).with(100)
          expect(CrmNotificationWorker).to receive(:perform_async).with(101)
          expect(CrmNotificationWorker).to receive(:perform_async).with(102)

          Rake.application.invoke_task 'crm:resync_charges'
        end

        it "should not filter by external_id" do
          expect(charges_relation).not_to receive(:where).with('external_id IS NOT NULL')
          allow(charges_relation).to receive(:select).with(:id).and_return([])

          Rake.application.invoke_task 'crm:resync_charges'
        end

        it "should filter by created_date if FROM_DATE argument set" do
          ENV['FROM_DATE'] = '2014-12-31 11:59:00 pm'
          expect(charges_relation).to receive(:where).with('created_at > ?', Time.parse('2014-12-31 11:59:00 pm')).and_return(charges_relation)
          allow(charges_relation).to receive(:select).with(:id).and_return([])

          Rake.application.invoke_task 'crm:resync_charges'
        end
      end

      context "CRM is AK" do
        it "should filter by external_id" do
          expect(charges_relation).to receive(:where).with('external_id IS NOT NULL').and_return(charges_relation)
          allow(charges_relation).to receive(:select).with(:id).and_return([])

          Rake.application.invoke_task 'crm:resync_charges'
        end
      end
    end
  end
end
