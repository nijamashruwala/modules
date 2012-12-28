#/etc/puppetlabs/puppet/modules/site/manifests/user_accounts.pp
class site::user_accounts {
  class {'pe_accounts':
    manage_users   => false,
    manage_groups  => false,
    manage_sudoers => true,
  }
}

