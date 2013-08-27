#/etc/puppetlabs/puppet/modules/apigee/manifests/openldap.pp
# This is the class definition for openldap components.
class apigee::openldap inherits apigee {
  $my_conf = "$my_root_dir/conf/openldap"

# Tune OpenLdap to reduce number of threads. Threadpool over number of CPUs
# causes strange CPU spikes.
# Create a symlink to the file because augeas doesn't handle filenames with '=' in them
  $target_dir = "${my_conf}/slapd.d/"
  $target_file = 'cn=config.ldif'
  file { 'conf_openldap_slapd_config_link':
    path   => "${target_dir}config.ldif",
    ensure => link,
    target => "${target_dir}${target_file}",
    owner  => "apigee",
    group  => "apigee",
  }
# /mnt/apigee4/conf/openldap/slapd.d/cn=config.ldif
  $context_conf = "${target_dir}config.ldif"
  augeas { "conf_openldap_slapd_config.ldif":
    lens    => "Ldif.lns",
    incl    => "${context_conf}",
    context => "/files${context_conf}",
    changes => [ "set @content/1/olcThreads 2",
                 "set @content/1/olcToolThreads 1",
                 "set @content/1/olcConnMaxPending 500",
                 "set @content/1/olcConnMaxPendingAuth 5000",
                 "set @content/1/olcSockbufMaxIncoming 1310715",
                 "set @content/1/olcSockbufMaxIncomingAuth 83886075",
      ],
    #requires => 'conf_openldap_slapd_config_link',
  }
# Sample code
#   file { 'apigee_opdk_license':
#     owner  => "apigee",
#     group  => "apigee",
#     path   => "$my_conf_ms/license.txt",
#     ensure => file,
#     mode   => '0777',
#     source => "puppet:///modules/apigee/license.txt",
#   }

# Enable/Disable cassandra caching for API products, uses augeas
#  $toggle_value = hiera('cass_row_caching')
#  $context_conf = "$my_conf_ms/keymanagement.properties"
#  augeas { "conf_keymanagement.properties":
#    lens    => "Properties.lns",
#    incl    => "$context_conf",
#    context => "/files$context_conf",
#    changes => [ "set kms_cache_memory_element_enable $toggle_value" ],
#  }

# Change logging and log rotation settings, uses augeas
#
# set /augeas/load/xml/lens "Xml.lns"
# set /augeas/load/xml/incl "/mnt/apigee4/conf/apigee/management-server/logback.xml"
#  $context = "$my_conf_ms/logback.xml"
#     <root level="${log.level:-DEBUG}">
#  $my_log_level = hiera('root_log_level')
#  $pre = '${log.level:-'
#  $post = '}'
#  $rootloglevel = "${pre}${my_log_level}${post}"
#  augeas { "logback.xml":
#    lens    => "Xml.lns",
#    incl    => "$context",
#    context => "/files$context",
#    changes => [
#          "set configuration/root/#attribute/level $rootloglevel",
#      ],
#    }
}
