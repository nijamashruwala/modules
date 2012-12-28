#/etc/puppetlabs/puppet/modules/apigee/manifests/gw_logging.pp
class apigee::gw_logging {
  file { 'get_logs.sh':
    ensure => file,
    path   => '/root/get_logs.sh',
    mode   => 'a=r,u+wx',             # All can read, user can write & execute
    owner  => 'root',
    source => 'puppet:///modules/apigee/get_logs.sh',
  }
}

