#/etc/puppetlabs/puppet/modules/apigee/manifests/init.pp

class apigee::labs inherits apigee {
  # Variables will eventually go here, I think

#  service { 'apigee':
  # This defines software installed by the OPDK and how puppet should interact
  # with is. Eventually, OPDK definition could go somewhere here too.
#  ensure    => 'running',
#  name      => 'apigee',
#  enable    => true,
#  start     => '/opt/apigee/bin/all-start.sh',
#  start     => '/etc/init.d/apigee start',
#  stop      => '/opt/apigee/bin/all-stop.sh',
#  stop      => '/etc/init.d/apigee stop',
#  status    => '/opt/apigee/bin/all-status.sh',
#  status    => '/etc/init.d/apigee status',
#  subscribe => File['apigee_init'],
#  }

#  file { 'apigee_init':
#    path    => '/etc/init.d/apigee',
#    ensure  => file,
#    mode    => '0755',
    #content => template('apigee/apigee_init.erb'),
#    source => "puppet:///modules/apigee/apigee_init.sh",
#  }

#  file { 'apigee_jvm_tuning':
#    path   =>
#    ensure =>
#    mode   =>
#    source?
#  }
  $hiera_var = hiera('monkey')

  notify { "labs":
    withpath => "true",
    name     => "my_lib_thirdparty_dir is $my_lib_thirdparty_dir, hiera var monkey is $hiera_var",
  }
}
