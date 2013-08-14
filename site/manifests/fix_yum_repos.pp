# /etc/puppetlabs/puppet/modules/site/manifests/basic.pp
class site::fix_yum_repos {
  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {
    yumrepo { 'rpmforge':
      enabled     => '0',
#      includepkgs => '',
    }
  }
}

