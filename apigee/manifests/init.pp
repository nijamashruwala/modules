#/etc/puppetlabs/puppet/modules/apigee/manifests/init.pp

class apigee {
  # Include other modules and classes
  include site::packages
  include apigee::gw_logging
  # Variables will eventually go here, I think


  service { 'apigee':
  # This defines software installed by the OPDK and how puppet should interact
  # with is. Eventually, OPDK definition could go somewhere here too.
  name       => 'apigee', 
  ensure     => 'running',
  enable     => 'true',
  hasrestart => 'true',
  hasstatus  => 'true',
  require    => [ 
#  subscribe => [ 
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
