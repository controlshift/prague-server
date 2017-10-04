module Queries
  class ChargesForTagExport < Export
    attr_accessor :tag

    def klass
      Charge
    end

    def sql
      ActiveRecord::Base.send(:sanitize_sql_array,
        ["WITH charges_for_tag AS (
            SELECT charges.id as charge_id,
                   charges.customer_id
            FROM charges
            JOIN charges_tags ON charges_tags.charge_id = charges.id
            WHERE charges_tags.tag_id = :tag_id
            AND charges.organization_id = :organization_id
          ),
          charges_customers AS (
            SELECT charges_for_tag.charge_id,
                   customers.id AS customer_id,
                   string_agg(tags.name, ',') AS tags
            FROM charges_for_tag
            JOIN customers ON customers.id = charges_for_tag.customer_id
            LEFT JOIN charges_tags ON charges_tags.charge_id = charges_for_tag.charge_id
            LEFT JOIN tags ON tags.id = charges_tags.tag_id
            GROUP BY charges_for_tag.charge_id, customers.id
            )
          SELECT customers.first_name, customers.last_name, customers.email, charges.amount, charges.currency, charges.config, charges.status, charges.created_at, charges_customers.tags
          FROM charges_customers
          JOIN charges ON charges.id = charges_customers.charge_id
          JOIN customers ON customers.id = charges_customers.customer_id",
          tag_id: tag.id, organization_id: tag.organization.id
        ])
    end

    def name
      "charges-#{tag.organization.slug}-#{tag.name}"
    end
  end
end
