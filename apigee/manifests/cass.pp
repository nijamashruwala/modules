#/etc/puppetlabs/puppet/modules/apigee/manifests/cass.pp
# This is the class definition for all cassandra datastores. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::cass inherits apigee {
  package { 'jna':
    ensure => latest,
  }
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
