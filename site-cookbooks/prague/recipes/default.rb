include_recipe 'apt'
include_recipe "postgresql::server"
include_recipe "postgresql::client"
include_recipe 'prague::postgres'
include_recipe "redisio"
include_recipe "redisio::install"
include_recipe "redisio::enable"


include_recipe 'prague::ruby'
include_recipe 'prague::rails'
