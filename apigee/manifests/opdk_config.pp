#/etc/puppetlabs/puppet/modules/apigee/manifests/opdk_config.pp
class apigee::opdk_config inherits apigee {
  file { 'apigee_opdk_license':
    owner  => "apigee",
    group  => "apigee",
    path   => "/home/apigee/license.txt",
    ensure => file,
    mode   => '0777',
    source => "puppet:///modules/apigee/license.txt",
  }
}
class { 'apigee::opdk_config':
}
