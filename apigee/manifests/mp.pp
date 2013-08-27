#/etc/puppetlabs/puppet/modules/apigee/manifests/mp.pp
# This is the class definition for all message processors. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::mp inherits apigee {
  include apigee::threadpool
  include apigee::mindapi
  include apigee::troubleshooting_utils

  $my_conf = "$apigee_conf/message-processor"

# Enable/Disable cassandra caching for API products, uses augeas
  $toggle_value = hiera('cass_row_caching')
  $context_conf = "$my_conf/keymanagement.properties"
  augeas { "conf_keymanagement.properties":
    lens    => "Properties.lns",
    incl    => "$context_conf",
    context => "/files$context_conf",
    changes => [ "set kms_cache_memory_element_enable $toggle_value" ],
  }

# Change logging and log rotation settings, uses augeas
#
# set /augeas/load/xml/lens "Xml.lns"
# set /augeas/load/xml/incl "/mnt/apigee4/conf/apigee/message-processor/logback.xml"
  $context = "$my_conf/logback.xml"
  $urllog_value = '${data.dir:-..}/logs/urllog-%d{yyyy-MM-dd}.%i.log.gz'
  $startuperr_value = '${data.dir:-..}/logs/startupruntimeerrors-%d{yyyy-MM-dd}.%i.log.gz'
  $translog_value = '${data.dir:-..}/logs/transactions-%d{yyyy-MM-dd}.%i.log.gz'
  $accesslog_value = '${data.dir:-..}/logs/access-%d{yyyy-MM-dd}.%i.log.gz'
#     <root level="${log.level:-DEBUG}">
  $my_log_level = hiera('root_log_level')
  $pre = '${log.level:-'
  $post = '}'
  $rootloglevel = "${pre}${my_log_level}${post}"
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

# Using a parameterized class. Takes in the location of the conf directory.
# This handles keep-alives and other connection tuning
  class { 'apigee::http_properties':
    conf => "$my_conf",
  }

# Tune connections to avoid time-waits, uses augeas and POSIX ERE for regexp
# set /augeas/load/properties/lens "Properties.lns"
# set /augeas/load/properties/incl "/mnt/apigee4/conf/apigee/message-processor/http.properties"
# defvar loc /files/mnt/apigee4/conf/apigee/message-processor/http.properties
# ins HTTPServer.max.keepalive.clients after $loc/#comment[. =~ regexp('HTTPServer.max.keepalive.clients.+')]
# set HTTPServer.max.keepalive.clients -1
#  $context_http_prop = "$my_conf/http.properties"
#  $keepalive_clients = "-1"
#  augeas { "http.properties":
#    lens    => "Properties.lns",
#    incl    => "$context_http_prop",
#    context => "/files$context_http_prop",
#    changes => [
#      "ins HTTPServer.max.keepalive.clients after #comment[ .=~ regexp('HTTPServer.max.keepalive.clients.+') ]",
#      "set HTTPServer.max.keepalive.clients $keepalive_clients",
#      ],
#    onlyif => "get HTTPServer.max.keepalive.clients != $keepalive_clients",
#    }
#  notice("Applying apigee::mp class; urllog_value is $urllog_value ; startuperr_value is $startuperr_value ; translog_value is $translog_value ; accesslog_value is $accesslog_value")
}
