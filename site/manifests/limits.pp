# /etc/puppetlabs/puppet/modules/site/manifests/limits.pp
# Depends on limits/limits.tmpl
class site::limits {
  file { '/etc/security/limits.conf':
    ensure  => 'file',
#    target  => '/etc/security/limits.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('site/limits.tmpl'),
  }
}
