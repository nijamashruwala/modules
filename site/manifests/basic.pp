# /etc/puppetlabs/puppet/modules/site/manifests/basic.pp
class site::basic {
#  if $osfamily != 'windows' {
    #include motd
    include enable_scp
    include users 
    include groups 
#  }
}
