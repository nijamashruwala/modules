#/etc/puppetlabs/puppet/modules/apigee/manifests/gw_logging.pp
# This is deprecated and should not be used or included in other classes
class apigee::gw_logging {
  file { 'get_logs.sh':
    ensure => file,
    path   => '/root/get_logs.sh',
    mode   => 'a=r,u+wx',             # All can read, user can write & execute
    owner  => 'root',
    source => 'puppet:///modules/apigee/get_logs.sh',
  }
}

