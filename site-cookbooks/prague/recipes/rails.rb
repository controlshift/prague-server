# required for asset pipeline
package 'nodejs'
package 'git'
package 'libqt4-dev'

execute 'sudo bundle install' do
  cwd '/home/vagrant/code'
  user 'vagrant'
end

# execute 'bundle exec rake db:create' do
#   cwd '/home/vagrant/code'
#   user 'vagrant'
# end
#
# execute 'bundle exec rake db:migrate' do
#   cwd '/home/vagrant/code'
#   user 'vagrant'
# end