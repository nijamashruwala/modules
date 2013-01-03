# /etc/puppetlabs/puppet/modules/site/manifests/enable_scp.pp
class site::enable_scp {
  file { 'security.sh':
    ensure  => 'file',
    path    => '/etc/profile.d/security.sh',
    content => 'puppet:///site/security.sh',
  }
}
