# /etc/puppetlabs/puppet/modules/site/manifests/basic.pp
class site::basic {
  if $osfamily != 'windows' {
    #include motd
    include groups
    include users
  }
  filebucket { main:
    server => puppetmaster,
    path   => false,
    # The path => false line works around a known issue with the filebucket type.
  }
}
