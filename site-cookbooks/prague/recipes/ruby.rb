package 'libxslt-dev'
package 'libxml2-dev'
package 'build-essential'
package 'libpq-dev'
package 'libsqlite3-dev'

package 'software-properties-common'

execute 'apt-add-repository ppa:brightbox/ruby-ng -y' do
  not_if 'which ruby | grep -c 2.1'
end

execute 'apt-get update' do
  ignore_failure true
end

package 'ruby2.1'
package 'ruby2.1-dev'

gem_package 'bundler' do
  gem_binary('/usr/bin/gem2.1')
end

gem_package 'rails' do
  gem_binary('/usr/bin/gem2.1')
end