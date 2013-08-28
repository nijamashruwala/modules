# /etc/puppetlabs/puppet/modules/site/manifests/basic.pp
class site::basic {
  $my_manage_users_groups=hiera('manage_users_groups')
#  if $osfamily != 'windows' {
    #include motd
    include enable_scp
#  }
  if $my_manage_users_groups == 'true' {
    include users 
    include groups 
  }
# Is DIY IPsec enabled?
#  $autorouteipsec_enabled = hiera('autorouteipsec_enabled')
#  notify {"autorouteipsec_enabled is $autorouteipsec_enabled":
#    withpath => true,
#  }
#  if $autorouteipsec_enabled == 'true' {
#    include autoroute-ipsec
#  }
}
