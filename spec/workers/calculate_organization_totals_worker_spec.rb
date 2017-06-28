require 'spec_helper'

describe CalculateOrganizationTotalsWorker do
  let(:organization) { build_stubbed(:organization) }

  before :each do
    expect(Organization).to receive(:find).with(organization.id).and_return(organization)
  end

  it 'should reset redis data for tags and namespaces' do
    tags = build_stubbed_list(:tag, 3, organization: organization)
    tags_relation = double
    allow(tags_relation).to receive(:find_each) do |&block|
      tags.each(&block)
    end
    expect(organization).to receive(:tags).and_return(tags_relation)
    tags.each { |tag| expect(tag).to receive(:reset_redis_keys!) }

    namespaces = build_stubbed_list(:tag_namespace, 2, organization: organization)
    namespaces_relation = double
    allow(namespaces_relation).to receive(:find_each) do |&block|
      namespaces.each(&block)
    end
    expect(organization).to receive(:namespaces).and_return(namespaces_relation)
    namespaces.each { |namespace| expect(namespace).to receive(:reset_redis_keys!) }

    subject.perform(organization.id)
  end

  it 'should aggregate paid charges for all tags' do
    charges = build_stubbed_list(:charge, 3, paid: true, status: 'live')
    charge_amount = 0
    charges.each do |charge|
      charge_amount += 100.0
      expect(charge).to receive(:converted_amount).with(organization.currency).exactly(2).times.and_return(charge_amount)

      tags = build_stubbed_list(:tag, 2, organization: organization)
      tags.each {|tag| expect(tag).to receive(:incrby).with(charge_amount, status: charge.status, charge_date: charge.created_at) }
      tags_relation = double
      expect(tags_relation).to receive(:find_each) do |&block|
        tags.each(&block)
      end
      expect(charge).to receive(:tags).and_return(tags_relation)
    end
    charges_relation = double
    expect(charges_relation).to receive(:paid).and_return(charges_relation)
    allow(charges_relation).to receive(:find_each) do |&block|
      charges.each(&block)
    end
    expect(organization).to receive(:charges).and_return(charges_relation)

    subject.perform(organization.id)
  end
end
