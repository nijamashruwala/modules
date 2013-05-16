#/etc/puppetlabs/puppet/modules/apigee/manifests/init.pp

class apigee {
  # Include other modules and classes
  include site::packages
  include apigee::gw_logging
  # Variables will eventually go here, I think
  $my_mnt_dir = "/media/ephemeral0"
  $my_opdk_version = "4.21.0"
  $my_apigee_rpm_version = "1.0.0.1303142044"
  $my_root_dir = "$my_mnt_dir/apigee-$my_opdk_version"
  $my_run_dir = "$my_root_dir/opt/apigee"
  $my_lib_thirdparty_dir = "$my_run_dir/apigee-$my_apigee_rpm_version/lib/thirdparty"

  service { 'apigee':
  # This defines software installed by the OPDK and how puppet should interact
  # with is. Eventually, OPDK definition could go somewhere here too.
  name       => 'apigee', 
  ensure     => 'running',
  enable     => 'true',
  hasrestart => 'true',
  hasstatus  => 'true',
  require    => [ 
                 File['apigee_init'],
                 File['get_logs.sh'],
               ],
  }
  
  file { 'apigee_init':
    path    => '/etc/init.d/apigee',
    ensure  => file,
    mode    => '0755',
    #content => template('apigee/apigee_init.erb'),
    source => "puppet:///modules/apigee/apigee_init.sh",
  }
}
