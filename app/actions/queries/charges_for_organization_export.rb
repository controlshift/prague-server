module Queries
  class ChargesForOrganizationExport < Export
    attr_accessor :organization

    def klass
      Charge
    end

    def sql
      Charge.where(organization_id: organization.id).joins(:customer).select(['customers.first_name', 'customers.last_name', 'customers.email', 'charges.amount', 'charges.currency', 'charges.config', 'charges.status', 'charges.created_at']).to_sql
    end

    def name
      "charges-#{organization.slug}"
    end
  end
end