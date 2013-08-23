# /etc/puppetlabs/puppet/modules/site/manifests/packages.pp
class site::packages {
  package { 'bc':
    ensure => latest,
  }
  package { 'bind-utils':
    ensure => latest,
  }
  package { 'dos2unix':
    ensure => latest,
  }
  package { 'git':
    ensure => present,
  }
  package { 'libXt':
    ensure => present,
  }
  package { 'libXtst':
    ensure => present,
  }
  package { 'lsof':
    ensure => present,
  }
  package { 'man':
    ensure => latest,
  }
  package { 'nagios-plugins-all':
    ensure => latest,
  }
  package { 'nc':
    ensure => latest,
  }
  package { 'nmap':
    ensure => latest,
  }
#  package { 'nrpe':
#    ensure => latest,
#    require => Yumrepo[ "epel" ],
#  }
  package { 'openldap-clients':
    ensure => latest,
  }
  package { 'openssh-clients':
    ensure => latest,
  }
  package { 'openssl':
    ensure => latest,
  }
  package { 'patch':
    ensure => latest,
  }
  package { 'python-ldap':
    ensure => latest,
  }
  package { 'rsync':
    ensure => latest,
  }
  package { 'screen':
    ensure => latest,
  }
  package { 'ssldump':
    ensure => latest,
  }
  package { 'sysstat':
    ensure => latest,
  }
  package { 'tcpdump':
    ensure => latest,
  }
  package { 'telnet':
    ensure => latest,
  }
  package { 'traceroute':
    ensure => latest,
  }
  package { 'tree':
    ensure => latest,
  }
  package { 'vim-enhanced':
    ensure => latest,
  }
  package { 'unzip':
    ensure => latest,
  }
  package { 'which':
    ensure => latest,
  }
  package { 'yum-utils':
    ensure => latest,
  }
  package { 'zip':
    ensure => latest,
  }
}
# libXt libXtst
#class { 'site::packages': }
