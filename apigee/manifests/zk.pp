#/etc/puppetlabs/puppet/modules/apigee/manifests/zk.pp
# This is the class definition for all zookeeper nodes. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::zk inherits apigee {
}
