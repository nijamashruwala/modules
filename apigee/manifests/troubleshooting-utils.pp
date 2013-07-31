#/etc/puppetlabs/puppet/modules/apigee/manifests/troubleshooting-utils.pp
# Put troubleshooting utils on the servers

class apigee::troubleshooting_utils inherits apigee {
	$base_path='/home/apigee'
	file { 'sysinfo':
    path    => "$base_path/troubleshooting/sysinfo.py",
    ensure  => file,
    mode    => '0755',
    source => "puppet:///modules/apigee/sysinfo.py",
 }
	file { 'README-sysinfo':
    path    => "$base_path/troubleshooting/README-sysinfo.py",
    ensure  => file,
    mode    => '0755',
    source => "puppet:///modules/apigee/README-sysinfo.py",
 }
