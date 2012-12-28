# /etc/puppetlabs/puppet/modules/site/manifests/groups.pp
    class site::groups {
      # Shared groups:

      Group { ensure => present, }
      group {'developer':
        gid => '3003',
      }
      group {'sudonopw':
        gid => '3002',
      }
      group {'sudo':
        gid => '3001',
      }
      group {'admin':
        gid => '3000',
      }
      group {'nagios':
        gid => '550',
      }
    }
