#/etc/puppetlabs/puppet/modules/apigee/manifests/qpid.pp
# This is the class definition for all qpid servers. Per version fixes 
# go directly in the file. Reusable code, multiple version attributes and tuning 
# should get their own classes, and then be included in here
class apigee::qpid inherits apigee {

# TODO: Add this to root and apigee user's .bash_profile
#PATH=$PATH:/mnt/apigee4/share/apache-qpid/bin
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/apigee4/share/apache-qpid/lib64
#PYTHONPATH=$PYTHONPATH:/mnt/apigee4/share/apache-qpid/lib/python2.6/site-packages#export PATH
#export LD_LIBRARY_PATH
#export PYTHONPATH

# TODO: Add files in ../files/axload to $apigee_bin_dir

}
