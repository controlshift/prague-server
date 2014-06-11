require 'oauth2'
OAuth2::Client.any_instance.stub(:get_token).and_return(OAuth2::AccessToken.new(nil,nil,{'stripe_public_key' => 'xxx'}))
