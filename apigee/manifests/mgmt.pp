#/etc/puppetlabs/puppet/modules/apigee/manifests/mgmt.pp
class apigee::mgmt inherits apigee {
#   file { 'apigee_opdk_license':
#     owner  => "apigee",
#     group  => "apigee",
#     path   => "$my_conf_ms/license.txt",
#     ensure => file,
#     mode   => '0777',
#     source => "puppet:///modules/apigee/license.txt",
#   }
}
