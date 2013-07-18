#/etc/puppetlabs/puppet/modules/apigee/manifests/mp.pp
class apigee::mp inherits apigee {
  include apigee::threadpool
  include apigee::mindapi

# Enable/Disable cassandra caching for API products
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

# Change logging and log rotation settings, uses augeas
#
# set /augeas/load/xml/lens "Xml.lns"
# set /augeas/load/xml/incl "/mnt/apigee4/conf/apigee/message-processor/logback.xml"
# load
# print /files
  $context = "$my_conf_mp/logback.xml"
  $urllog_value = '${data.dir:-..}/logs/urllog-%d{yyyy-MM-dd}.%i.log.gz'
  $startuperr_value = '${data.dir:-..}/logs/startupruntimeerrors-%d{yyyy-MM-dd}.%i.log.gz'
  $translog_value = '${data.dir:-..}/logs/transactions-%d{yyyy-MM-dd}.%i.log.gz'
  $accesslog_value = '${data.dir:-..}/logs/access-%d{yyyy-MM-dd}.%i.log.gz'
#     <root level="${log.level:-DEBUG}">
  $rootloglevel = '${log.level:-INFO}'
  augeas { "logback.xml":
    lens    => "Xml.lns",
    incl    => "$context",
    context => "/files$context",
    # /files/mnt/apigee4/conf/apigee/message-processor/logback.xml/configuration/appender[3]/#attribute/name = "URLLOGFILE"
    # /files/mnt/apigee4/conf/apigee/message-processor/logback.xml/configuration/appender[3]/rollingPolicy/fileNamePattern/#text = "${data.dir:-..}/logs/system-%d{yyyy-MM-dd}.%i.log.gz"
    # set /files/test.xml/configuration/properties/property[#attribute/name='username']/#text NEWUSER
    changes => [ 
      "set configuration/appender[#attribute/name='URLLOGFILE']/rollingPolicy/fileNamePattern/#text $urllog_value", 
      "set configuration/appender[#attribute/name='STARTUP_RUNTIME_ERROR']/rollingPolicy/fileNamePattern/#text $startuperr_value", 
      "set configuration/appender[#attribute/name='TRANSACTION_LOGS']/rollingPolicy/fileNamePattern/#text $translog_value", 
      "set configuration/appender[#attribute/name='ACCESSINFO_LOGS']/rollingPolicy/fileNamePattern/#text $accesslog_value", 
      "set configuration/root/#attribute/level $rootloglevel",
      ],
    }

  notice("Applying apigee::mp class; urllog_value is $urllog_value ; startuperr_value is $startuperr_value ; translog_value is $translog_value ; accesslog_value is $accesslog_value")
}
