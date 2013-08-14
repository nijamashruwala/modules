#/etc/puppetlabs/puppet/modules/apigee/manifests/router.pp
# This is the class definition for all message routers. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::router inherits apigee {
  include apigee::troubleshooting_utils
}
