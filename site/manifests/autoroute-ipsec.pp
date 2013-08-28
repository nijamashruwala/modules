# /etc/puppetlabs/puppet/modules/site/manifests/autoroute-ipsec.pp
# Depends on templates/autoroute-ipsec
class site::autoroute-ipsec {
  notify { 'in site::autoroute-ipsec': }

  # Get the vars we will need to use from hiera
  $autorouteipsec_network = hiera('autorouteipsec_network')
  $autorouteipsec_netmask = hiera('autorouteipsec_netmask')
  # Define the config file
  file { 'autoroute-ipsec_config':
    ensure  => 'file',
    path    => '/etc/init.d/autoroute-ipsec',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('site/autoroute-ipsec.erb'),
  }
  # Define the service to start on boot and restart when the config changes
  service { 'autoroute-ipsec':	
    ensure    => running,
    enable    => true,
    subscribe => File['autoroute-ipsec_config'],
  }
  # Can manually test by checking the routing table with netstat -rn 
}
