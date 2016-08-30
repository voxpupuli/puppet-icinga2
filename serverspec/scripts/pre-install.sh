#rpm --import https://getfedora.org/static/352C64E5.txt
#rpm -q epel-release 1>/dev/null || yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
rpm -aq |grep puppetlabs-release 1>/dev/null || yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

rpm -q puppet-agent || yum install -y puppet-agent
