class CrmTest
  include ActiveModel::Model

  attr_accessor :crm

  def test!
    if crm.action_kit?
      ak = ActionKitRest.new(host: @crm.host, username: @crm.username, password: @crm.password )
      begin
        page = ak.donation_page.find(@crm.donation_page_name)
        if page.nil?
          errors.add(:base, 'Donation Page not found')
        end
      rescue ActionKitRest::Response::Unauthorized
        errors.add(:base, 'Invalid username or password')
      end
    end
  end

end
