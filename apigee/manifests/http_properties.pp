#/etc/puppetlabs/puppet/modules/apigee/manifests/http.properties.pp
# This is the class definition for the http.properties file. It is a
# parameterized class.
class apigee::http_properties ($conf) inherits apigee {
# Tune connections to avoid time-waits, uses augeas and POSIX ERE for regexp
# set /augeas/load/properties/lens "Properties.lns"
# set /augeas/load/properties/incl "/mnt/apigee4/conf/apigee/message-processor/http.properties"
# defvar loc /files/mnt/apigee4/conf/apigee/message-processor/http.properties
# ins HTTPServer.max.keepalive.clients after $loc/#comment[. =~ regexp('HTTPServer.max.keepalive.clients.+')]
# set HTTPServer.max.keepalive.clients -1
  $context = "$conf/http.properties"
  $keepalive_clients = "-1"
  augeas { "http.properties":
    lens    => "Properties.lns",
    incl    => "$context",
    context => "/files$context",
    changes => [
      "ins HTTPServer.max.keepalive.clients after #comment[ .=~ regexp('HTTPServer.max.keepalive.clients.+') ]",
      "set HTTPServer.max.keepalive.clients $keepalive_clients",
      ],
    onlyif => "get HTTPServer.max.keepalive.clients != $keepalive_clients",
    }
}
