gem list | grep puppet 1> /dev/null || gem install puppet

test -x /usr/bin/puppet.ruby2.1 && ln -s /usr/bin/puppet.ruby2.1 /usr/bin/puppet
