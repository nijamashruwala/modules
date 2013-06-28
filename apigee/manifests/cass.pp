#/etc/puppetlabs/puppet/modules/apigee/manifests/cass.pp
class apigee::cass inherits apigee {  
  package { 'jna':
    ensure => latest,
  }
}
