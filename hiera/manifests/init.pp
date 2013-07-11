# /etc/puppetlabs/puppet/modules/hiera/manifests
# Purpose: hiera set up for the puppetmaster
# Notes:
#       Cribbed heavily from Apigee GOC
#       May need to install the calling_module fact later
#
#class hiera(
#  $hiera_yaml='/etc/puppet/hiera.yaml',
#  $hiera_data="/etc/puppet/hieradata"
#)

class hiera(
  $hiera_yaml='/etc/puppetlabs/puppet/hiera.yaml',
  $hiera_data="<%= ${derived_mnt_dir %>/hiera/data"
) {
# $hiera_data= <%= hiera('mnt_dir') %> # Or something like this
  File {
    owner => '0',
    group => '0',
    mode  => '0644',
  }
# Using Puppet Enterprise, don't need this portion
#  file { "/usr/bin/hiera":
#    ensure  => present,
#    content => template('hiera/bin_hiera.erb'),
#    mode    => '0755',
#  }
  file { $hiera_data:
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
  }
  file { $hiera_yaml:
    ensure  => present,
    content => template('hiera/hiera.yaml.erb'),
  }
# Using Puppet Enterprise, do not want a link here
#  file { "/etc/hiera.yaml":
#    ensure => symlink,
#    target => $hiera_yaml,
#  }
#
#  exec { "hiera-gem-install":
#    command   => "/usr/bin/gem install -q -v 0.2.0 hiera",
#    creates   => '/usr/lib/ruby/gems/1.8/gems/hiera-0.2.0',
#    cwd       => "/tmp/",
#    logoutput => on_failure,
#    require   => Package['rubygems'],
#  }

}
