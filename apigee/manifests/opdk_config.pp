#/etc/puppetlabs/puppet/modules/apigee/manifests/opdk_config.pp
class apigee::opdk_config inherits apigee {

  $opdk_bin="apigee-gateway-$my_opdk_version.zip"

  file { 'apigee_opdk_license':
    owner  => "apigee",
    group  => "apigee",
    path   => "/home/apigee/license.txt",
    ensure => file,
    mode   => '0777',
    source => "puppet:///modules/apigee/license.txt",
  }

   file { 'OPDK':
     owner  => "apigee",
     group  => "apigee",
     path   => "$my_mnt_dir/$opdk_bin",
     ensure => file,
     mode   => '0777',
     source => "puppet:///modules/apigee/$opdk_bin",
   }
}
class { 'apigee::opdk_config':
}
