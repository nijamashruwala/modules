#/etc/puppetlabs/puppet/modules/apigee/manifests/init.pp
# This is for experimental code and should not be used except for development or
# testing
class apigee::labs inherits apigee {
# exec { "update $key$delimiter$value $file":
#        command => "sed --in-place='' --expression='s/^[[:space:]]*$key[[:space:]]*$delimiter.*$/$key$delimiter$value/g' $file",
#        unless => "grep -xqe '$key$delimiter$value' -- $file",
#        path => "/bin:/usr/bin:/usr/local/bin"
#    }    
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
  $mnt_dir = hiera('mnt_dir')
  $test_var = hiera('test_var')

  notify { "labs":
    withpath => "true",
    name     => "mnt_dir is $mnt_dir , test_var is $test_var",
  }
}
