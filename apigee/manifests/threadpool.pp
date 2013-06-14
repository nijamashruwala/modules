# /etc/puppetlabs/puppet/modules/apigee/manifests/threadpool.pp

class apigee::threadpool inherits apigee {
  file { 'threadpool.properties':
    ensure => file,
    owner  => 'pe-puppet',
    path   => "$my_conf_mp/threadpool.properties",
#    path   => "/opt/apigee/apigee-$my_apigee_rpm_version/conf-message-processor/threadpool.properties",
#    path   => '/opt/apigee/apigee-1.0.0.1303142044/conf-message-processor/threadpool.properties',
    mode   => '0755',
    source => 'puppet:///modules/apigee/mps_threadpool_properties',
    backup => main,
  }
}
