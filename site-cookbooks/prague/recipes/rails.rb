# required for asset pipeline
package 'nodejs'
package 'git'
package 'libqt4-dev'

execute 'sudo bundle install' do
  cwd '/home/vagrant/code'
  user 'vagrant'
  not_if 'cd /home/vagrant/code && bundle check' # This is not run inside /myapp
end
