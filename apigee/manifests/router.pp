#/etc/puppetlabs/puppet/modules/apigee/manifests/router.pp
# This is the class definition for all message routers. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::router inherits apigee {
  include apigee::troubleshooting_utils

  $my_conf = "$apigee_conf/router"

# Change logging and log rotation settings, uses augeas
# set /augeas/load/xml/lens "Xml.lns"
# set /augeas/load/xml/incl "/mnt/apigee4/conf/apigee/message-processor/logback.xml"
  $context = "$my_conf/logback.xml"
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
    changes => [
      "set configuration/root/#attribute/level $rootloglevel",
      ],
  }

# Using a parameterized class. Takes in the location of the conf directory.
# This handles keep-alives and other connection tuning
  class { 'apigee::http_properties':
    conf => "$my_conf",
  }

# Using a parameterized class. Takes in the location of the conf file.
# This handles jvm tuning
  class { 'apigee::share_apigee_bin_start':
    conf => '/mnt/apigee4/share/apigee/bin/start2',
  }
}
