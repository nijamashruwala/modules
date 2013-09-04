#/etc/puppetlabs/puppet/modules/apigee/manifests/cass.pp
# This is the class definition for all cassandra datastores. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::cass inherits apigee {
  $my_cass_dir = "/mnt/apigee4/share/apache-cassandra"
  $my_cass_lib = "$my_cass_dir/lib"
  package { 'jna':
    ensure => latest,
  }
# Add jna.jar to lib dir
  exec { 'cass_jna_jar_install':
    command => "cp /usr/share/java/jna.jar $my_cass_lib",
    creates => "$my_cass_lib/jna.jar",
    path    => "/bin:/usr/bin:/usr/local/bin",
    require => Package['jna'],
  }
# exec { "update $key$delimiter$value $file":
#        command => "sed --in-place='' --expression='s/^[[:space:]]*$key[[:space:]]*$delimiter.*$/$key$delimiter$value/g' $file",
#        unless => "grep -xqe '$key$delimiter$value' -- $file",
#        path => "/bin:/usr/bin:/usr/local/bin"
#    }
# Add cron for nodetool repair here
  cron { 'nodetool-repair':
    ensure  => present,
    command => "$my_cass_bin_dir/nodetool -h `hostname -i` repair -pr",
    user    => 'root',
    minute  => fqdn_rand( 30 ),
    weekday => fqdn_rand( 7 ),
    hour    => fqdn_rand( 24 ),
  }

#  notify { 'cass.pp':
#    withpath => true,
#    name     => "applying cass.pp, check for cronjob in root's crontab",
#  }
}
