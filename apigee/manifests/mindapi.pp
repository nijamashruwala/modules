#/etc/puppetlabs/puppet/modules/apigee/manifests/mindapi.pp
class apigee::mindapi inherits apigee {
  file { 'apigee_UnboundIdCustomMindProvider_jar':
#    path    => "$my_lib_thirdparty_dir/UnboundIdCustomMindProvider.jar",
    path    => "/media/ephemeral0/apigee-4.21.0/opt/apigee/apigee-1.0.0.1303142044/lib/thirdparty/UnboundIdCustomMindProvider.jar",
    ensure  => file,
    mode    => '0764',
    source => "puppet:///modules/apigee/UnboundIdCustomMindProvider.jar",
  }
}
