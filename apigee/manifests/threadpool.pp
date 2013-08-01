# /etc/puppetlabs/puppet/modules/apigee/manifests/threadpool.pp
# This is a class for threadpool tuning for the mps, and is included in mp.pp
class apigee::threadpool inherits apigee {
  file { 'threadpool.properties':
    ensure => file,
    owner  => 'apigee',
    group  => 'apigee',
    path   => "$my_conf_mp/threadpool.properties",
    mode   => '0755',
    source => 'puppet:///modules/apigee/mps_threadpool_properties',
    backup => main,
  }
}
