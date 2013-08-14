#/etc/puppetlabs/puppet/modules/apigee/manifests/ingest.pp
# This is the class definition for all ingest servers. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::ingest inherits apigee {
}
