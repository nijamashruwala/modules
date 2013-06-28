#/etc/puppetlabs/puppet/modules/apigee/manifests/mp.pp
class apigee::mp inherits apigee {
  include apigee::threadpool
  include apigee::mindapi

  notify { "Applying apigee::mp class, my_mnt_dir is $my_mnt_dir ; my_conf_mp is $my_conf_mp ":
    withpath => true,
  }
}
