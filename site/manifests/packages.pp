# /etc/puppetlabs/puppet/modules/site/manifests/packages.pp
class site::packages {
  package { 'augeas':
    ensure => latest,
  }
  package { 'bc':
    ensure => latest,
  }
  package { 'bind-utils':
    ensure => latest,
  }
#  package { 'jna':
#    ensure => latest,
#  }
  package { 'man':
    ensure => latest,
  }
  package { 'nc':
    ensure => latest,
  }
  package { 'nmap':
    ensure => latest,
  }
  package { 'openssh-clients':
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
  package { 'sysstat':
    ensure => latest,
  }
  package { 'tcpdump':
    ensure => latest,
  }
  package { 'telnet':
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

class {'site::packages': }
