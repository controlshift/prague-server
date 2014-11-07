node.default['postgresql']['contrib']['extensions'] = [
  "pageinspect",
  "pg_buffercache",
  "pg_freespacemap",
  "pgrowlocks",
  "pg_stat_statements",
  "pgstattuple",
  "hstore"
]


node.default['postgresql']['password'] =  { postgres: ''}
node.default['postgresql']['pg_hba'] = [{:comment => '# Trust all',   :type => 'local', :db => 'all', :user => 'all', :addr => nil,            :method => 'trust'},
                                        {:comment => '# Over IP too', :type => 'host',  :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'}
                                       ]
