# /etc/puppetlabs/puppet/modules/apigee/manifests/threadpool.pp

class apigee::threadpool {
  file { 'threadpool.properties':
    ensure => file,
    path   => '/opt/apigee/apigee-1.0.0.1303142044/conf-message-processor/threadpool.properties',
    mode   => '0755',
    source => 'puppet:///modules/apigee/mps_threadpool_properties',
    backup => main,
  }
}
