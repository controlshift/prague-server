execute 'createuser' do
  guard = <<-EOH
    psql -U postgres -c "select * from pg_user where
    usename='vagrant'" |
    grep -c vagrant
  EOH

  user 'postgres'
  command 'createuser -s vagrant'
  not_if guard, user: 'postgres'
end

package 'postgresql-contrib'