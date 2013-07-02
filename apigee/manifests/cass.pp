#/etc/puppetlabs/puppet/modules/apigee/manifests/cass.pp
class apigee::cass inherits apigee {  
  package { 'jna':
    ensure => latest,
  }
# Add cron for nodetool repair here
  cron { 'nodetool-repair':
    ensure  => present,
    command => "$my_cass_bin_dir/nodetool -h `hostname -i` repair -pr",
    user    => 'root',
    weekday => fqdn_rand( 7 ),
    hour    => fqdn_rand( 24 ),
  }

  notify { 'cass.pp':
    withpath => true,
    name     => "applying cass.pp, check for cronjob in root's crontab",
  }
}
