# /etc/puppetlabs/puppet/modules/site/manifests/known_hosts.pp
class site::known_hosts {
  # Include partial hostname 'app1.site' in hosts like 'app1.site.company.com'.
  #$partial_hostname = regsubst($fqdn, '\.company\.com$', '')
  #if $partial_hostname == $hostname {
  #  $host_aliases = [ $ipaddress, $hostname ]
  #} else {
    #$host_aliases = [ $ipaddress, $hostname, $partial_hostname ]
    $host_aliases = [ $ipaddress, $hostname, $fqdn ]
  #}

  # Export hostkeys from all hosts.
  @@sshkey { $fqdn:
    ensure       => present,
    host_aliases => $host_aliases,
    type         => 'rsa',
    key          => $sshrsakey,
  }

  # Import hostkeys to all hosts.
  Sshkey <<| |>>
}

class { 'site::known_hosts': }
