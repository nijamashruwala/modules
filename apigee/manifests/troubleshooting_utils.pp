#/etc/puppetlabs/puppet/modules/apigee/manifests/troubleshooting-utils.pp
# Put troubleshooting utils on the servers

class apigee::troubleshooting_utils inherits apigee {
  $base_path='/home/apigee'

  # Because puppet does not autocreate required directories
  $util_dir="$base_path/troubleshooting_utils"
  file { 'troubleshooting_dir':
    path   => "$util_dir",
    ensure => directory,
  }
  file { 'sysinfo':
    path    => "$util_dir/sysinfo.py",
    ensure  => file,
    mode    => '0755',
    source => "puppet:///modules/apigee/sysinfo.py",
    require    => File['troubleshooting_dir'],
  }
  file { 'README-sysinfo':
    path    => "$util_dir/README-sysinfo.py",
    ensure  => file,
    mode    => '0755',
    source => "puppet:///modules/apigee/README-sysinfo.py",
    require    => File['troubleshooting_dir'],
  }
}
