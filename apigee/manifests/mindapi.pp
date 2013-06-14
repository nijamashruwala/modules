#/etc/puppetlabs/puppet/modules/apigee/manifests/mindapi.pp
class apigee::mindapi inherits apigee {
  file { 'apigee_UnboundIdCustomMindProvider_jar':
    path    => "$my_lib_thirdparty_dir/UnboundIdCustomMindProvider.jar",
    ensure  => file,
    mode    => '0764',
    source => "puppet:///modules/apigee/UnboundIdCustomMindProvider.jar",
  }
#  notify { "unboundidcustommindprovider_jar":
#    withpath => "true",
#    name     => "my_lib_thirdparty_dir is $my_lib_thirdparty_dir",
#  }
}
class { 'apigee::mindapi':
}
