#/etc/puppetlabs/puppet/modules/apigee/manifests/mp.pp
class apigee::mp inherits apigee {
  include apigee::threadpool
  include apigee::mindapi

# Enable cassandra caching for API products
# Can this be replaced by an augeas call?
  file { 'conf_keymanagement.properties':
    path => "$my_conf_mp/keymanagement.properties",
  }->
  file_line { 'enable_API_caching_mp_part1':
    ensure => present,
    path   => "$my_conf_mp/keymanagement.properties",
    line   => "kms_cache_memory_element_enable=true",
  }
  file_line { 'enable_API_caching_mp_part2':
    ensure => absent,
    path   => "$my_conf_mp/keymanagement.properties",
    line   => "kms_cache_memory_element_enable=false",
  }

#  notify { "Applying apigee::mp class, my_mnt_dir is $my_mnt_dir ; my_conf_mp is $my_conf_mp ":
#    withpath => true,
#  }
}
