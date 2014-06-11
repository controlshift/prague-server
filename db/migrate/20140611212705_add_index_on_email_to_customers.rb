class AddIndexOnEmailToCustomers < ActiveRecord::Migration
  def change
    associations = [:has_one, :has_many].inject([]) do |names, assoc|
      names += Customer.reflect_on_all_associations(assoc).map(&:name)
      names
    end

    duplicate_emails = Customer.select('email, count(email)').group('email').having('count(email) > 1').pluck(:email)

    duplicate_emails.each do |email|
      customers = Customer.where(:email => email)
      current_customer = customers.order('updated_at DESC').first

      customers.each do |customer|
        associations.each do |association|
          next unless customer.send(association)
          customer.send(association).update_all :customer_id => current_customer.id
        end
      end

      customers = customers.to_a
      customers.keep_if { |u| u.id != current_customer.id }
      customers.map(&:destroy)
    end
    add_index :customers, :email, :unique => true
  end
end
