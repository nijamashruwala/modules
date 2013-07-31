#/etc/puppetlabs/puppet/modules/apigee/manifests/mgmt.pp
class apigee::mgmt inherits apigee {
#   file { 'apigee_opdk_license':
#     owner  => "apigee",
#     group  => "apigee",
#     path   => "$my_conf_ms/license.txt",
#     ensure => file,
#     mode   => '0777',
#     source => "puppet:///modules/apigee/license.txt",
#   }

# Enable/Disable cassandra caching for API products, uses augeas
  $toggle_value = "true"
  $context_conf = "$my_conf_mp/keymanagement.properties"
  augeas { "conf_keymanagement.properties":
    lens    => "Properties.lns",
    incl    => "$context_conf",
    context => "/files$context_conf",
    changes => [ "set kms_cache_memory_element_enable $toggle_value" ],
  }

# Change logging and log rotation settings, uses augeas
#
# set /augeas/load/xml/lens "Xml.lns"
# set /augeas/load/xml/incl "/mnt/apigee4/conf/apigee/management-server/logback.xml"
  $context = "$my_conf_ms/logback.xml"
#  $urllog_value = '${data.dir:-..}/logs/urllog-%d{yyyy-MM-dd}.%i.log.gz'
#  $startuperr_value = '${data.dir:-..}/logs/startupruntimeerrors-%d{yyyy-MM-dd}.%i.log.gz'
#  $translog_value = '${data.dir:-..}/logs/transactions-%d{yyyy-MM-dd}.%i.log.gz'
#  $accesslog_value = '${data.dir:-..}/logs/access-%d{yyyy-MM-dd}.%i.log.gz'
#     <root level="${log.level:-DEBUG}">
  $my_log_level = hiera('root_log_level')
  $pre = '${log.level:-'
  $post = '}'
  $rootloglevel = "${pre}${my_log_level}${post}"
  augeas { "logback.xml":
    lens    => "Xml.lns",
    incl    => "$context",
    context => "/files$context",
    # /files/mnt/apigee4/conf/apigee/management-server/logback.xml/configuration/appender[3]/#attribute/name = "URLLOGFILE"
    # /files/mnt/apigee4/conf/apigee/management-server/logback.xml/configuration/appender[3]/rollingPolicy/fileNamePattern/#text = "${data.dir:-..}/logs/system-%d{yyyy-MM-dd}.%i.log.gz"
    # set /files/test.xml/configuration/properties/property[#attribute/name='username']/#text NEWUSER
#    changes => [
#      "set configuration/appender[#attribute/name='URLLOGFILE']/rollingPolicy/fileNamePattern/#text $urllog_value",
#      "set configuration/appender[#attribute/name='STARTUP_RUNTIME_ERROR']/rollingPolicy/fileNamePattern/#text $startuperr_value",
#      "set configuration/appender[#attribute/name='TRANSACTION_LOGS']/rollingPolicy/fileNamePattern/#text $translog_value",
#      "set configuration/appender[#attribute/name='ACCESSINFO_LOGS']/rollingPolicy/fileNamePattern/#text $accesslog_value",
#      "set configuration/root/#attribute/level $rootloglevel",
#      ],
    changes => [
          "set configuration/root/#attribute/level $rootloglevel",
      ],
    }


}
