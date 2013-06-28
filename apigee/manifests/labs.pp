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

  file { 'mp_cass_caching':
    path   => "$my_conf_mp/keymanagement.properties",
    ensure => file,
  }->
  file_line { 'mp_cass_caching_enable':
    ensure => present,
    path   => "$my_conf_mp/keymanagement.properties",
    line   => "kms_cache_memory_element_enable=true",
  }
  

#  $mnt_dir = hiera('mnt_dir')
#  $test_var = hiera('test_var')

  notify { "labs":
    withpath => "true",
    name     => "my_conf_mp is $my_conf_mp, mnt_dir is $mnt_dir",
  }
}
