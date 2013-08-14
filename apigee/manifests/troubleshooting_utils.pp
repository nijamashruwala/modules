#/etc/puppetlabs/puppet/modules/apigee/manifests/troubleshooting-utils.pp
# This class is to define generic trouble shooting utils.
class apigee::troubleshooting_utils inherits apigee {
  # Because puppet does not autocreate required directories
  $util_dir="$apigee_user_home/troubleshooting_utils"
  file { 'troubleshooting_dir':
    path   => "$util_dir",
    ensure => directory,
  }
  # The python app from Vaidhy that will get system state and is able to dump 
  # that state to an ftp site. Shoudl only be included in mp.pp and router.pp
  file { 'sysinfo':
    path    => "$util_dir/sysinfo.py",
    ensure  => file,
    mode    => '0755',
    source  => "puppet:///modules/apigee/sysinfo.py",
    require => File['troubleshooting_dir'],
  }
  file { 'README-sysinfo':
    path    => "$util_dir/README-sysinfo.py",
    ensure  => file,
    mode    => '0755',
    source  => "puppet:///modules/apigee/README-sysinfo.py",
    require => File['troubleshooting_dir'],
  }
}
