class BlueStateNotifier
  CARD_MAPPING =  {'Visa' => 'vs', 'American Express' => 'ax' , 'MasterCard' => 'mc', 'Discover' => 'ds', 'JCB' => 'ck', 'Diners Club' => 'ck',  'Unknown' => 'ck'}

  def process(charge)
    crm = charge.organization.crm
    connection = BlueStateDigital::Connection.new(host: crm.host, api_id: crm.username, api_secret: crm.password)
    contribution = BlueStateDigital::Contribution.new(external_id: charge.id,
                                       firstname: charge.customer.first_name,
                                       lastname: charge.customer.last_name,
                                       transaction_dt: charge.created_at,
                                       transaction_amt: charge.amount,
                                       cc_type_cd: CARD_MAPPING[charge.card['brand']],
                                       gateway_transaction_id: charge.stripe_id,
                                       source: 'takecharge',
                                       zip: charge.customer.zip,
                                       country: charge.customer.country,
                                       email: charge.customer.email,
                                       connection: connection)

    contribution.save
  end

  def card_mapping
  end
end