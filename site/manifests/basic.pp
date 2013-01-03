# /etc/puppetlabs/puppet/modules/site/manifests/basic.pp
class site::basic {
  if $osfamily != 'windows' {
    #include motd
    include groups
    include users
    include enable_scp
  }
}
