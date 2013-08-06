#/etc/puppetlabs/puppet/modules/apigee/manifests/init.pp
# This is the global class definition for the main apigee service. Reusable code,
# multiple version attributes and tuning should get their own classes, and then
# be included in the relevant subclasses
class apigee {
  # Include other modules and classes
  include site::packages

  # Variables used by this and child classes
  # Example getting data from hiera
  $apigee_user = hiera('apigee_user')
  $apigee_user_home = hiera('apigee_user_home')
  $my_opdk_version = hiera('opdk_version')
  $my_apigee_rpm_version2 = hiera('apigee_rpm_version')
  $my_apigee_rpm_version = hiera('apigee_rpm_version')
  # Example getting data from facter
  $my_mnt_dir = "${derived_mnt_dir}"
  $my_root_dir = "$my_mnt_dir/apigee4"
  $my_run_dir = "$my_root_dir/bin"
  $my_lib_thirdparty_dir = "$my_root_dir/share/apigee/lib/thirdparty"
  $my_conf_ms = "$my_root_dir/conf/apigee/management-server"
  $my_conf_router = "$my_root_dir/conf/apigee/router"
  $my_conf_mp = "$my_root_dir/conf/apigee/message-processor"
  $my_cass_bin_dir = "$my_root_dir/share/apache-cassandra-1.0.8/bin"

#  notify { "Applying apigee class, role is ${role} number is ${rolenumber} ":
#    withpath => true,
#  }

#  service { 'apigee':
  # This defines software installed by the OPDK and how puppet should interact
  # with is. Eventually, OPDK definition could go somewhere here too.
#   name       => 'apigee',
#   ensure     => 'running',
#   enable     => 'true',
#   hasrestart => 'true',
#   hasstatus  => 'true',
#   require    => [
#                  File['apigee_init'],
#                  File['get_logs.sh'],
#                ],
#   }
#
#   file { 'apigee_init':
#     path    => '/etc/init.d/apigee',
#     ensure  => file,
#     mode    => '0755',
#     #content => template('apigee/apigee_init.erb'),
#     source => "puppet:///modules/apigee/apigee_init.sh",
#   }
# }
}
