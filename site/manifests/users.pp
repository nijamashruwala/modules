# /etc/puppetlabs/puppet/modules/site/manifests/users.pp
class site::users {
# Declaring a dependency: we require several shared groups from the
# site::groups class (see below).
  Class[site::groups] -> Class[site::users]

  # Setting resource defaults for user accounts:
  Pe_accounts::User {
    shell      => '/bin/bash',
    managehome => true,
  }

  # Declaring our pe_accounts::user resources:
  # Utility accounts first
  user {'nagios':
    managehome => false,
    comment    => 'Nagios user',
    shell      => '/bin/bash',
    uid        => '550',
    gid        => '550',
    groups     => ['sudonopw'],
#    home       => '/var/log/nagios',
  }
  # Set perms on /var/log/nagios home dir to 755 instead of the default 700
  file { '/var/log/nagios':
    ensure => directory,
    owner  => 'nagios',
    mode   => '0755',
  }
  # Manage root's ssh keys
  file { 
    'root_ssh':
      ensure => directory,
      owner  => 'root',
      mode   => 700,
      path   => '/root/.ssh';
    'root_ssh_priv_key':
      ensure  => file,
      owner   => 'root',
      mode    => 600,
      path    => '/root/.ssh/id_rsa',
      source => "puppet:///modules/site/root_id_rsa";
    'root_ssh_pub_key':
      ensure  => file,
      owner   => 'root',
      mode    => 644,
      path    => '/root/.ssh/id_rsa.pub',
      source => "puppet:///modules/site/root_id_rsa_pub";
  }
  file { 'root_authorized_keys':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => 600,
      path   => '/root/.ssh/authorized_keys';
  }->
  file_line { 'root_ssh_key_authorized_keys':
      ensure    => present,
      path      => '/root/.ssh/authorized_keys',
      line      => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvLkIJSIMF4lSzR6uAbHl5ZWwaw1VHQb0OEZWgL3TN1FoTLU4BmQIcN7B8w8JY0gpWBVkIJzFgs/kTt+m8Hd55gHb8mkc4LcQLnGjGrAEs1sHXIDwxq6yY0Fo+CRJsr44SP6Et+PyqGEm8R4/W5ILppIDlsQYd1eRGiGFJXb+/KEiPNSOM9RdLgd2IU1oDkI/V2v/i+u4sYZUuxm9KE83lHq2MZqbwuVoqQjeoGkrZ+P2o7Uh1RZDJm9uCbqOSSxAT34tRH/CwTsPmMG01ci9mlN5xybeDORrYABJBhkIhktBW/cTUvvTXIkX3IXdUS+rSALPs9t70zLr5ROELx0cZw== root@puppetmaster',
  }

  # Now the regular user accounts
  pe_accounts::user {'nija':
    comment => 'Nija Mashruwala',
    groups  => ['admin', 'sudonopw'],
    uid     => '600',
    gid     => '600',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDC6dV2fLkXXIxVCYTsqVqzKvaWaXTJC+ThicEPJIDzY1imIHFpk9QfClMx1ijTUNl507gIjpJ6+LmEyEhyAmeeQyKyzO/aELBKbI1Y+ntFH0bhy+ktm2b/BIXCLyYozT/W+UbNbfCEYD8E0moVTLVfsABDAMF5t4dq6V4w9TbW6w== nija@apigee.com'],
  }
  pe_accounts::user {'bpasanen':
    comment => 'Brian Pasanen',
    groups  => ['admin', 'sudonopw'],
    uid     => '601',
    gid     => '601',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/4i/WJ/IAMQ6irsX8aS2wX/yQ7vCHwXkwwx/rrNsX31/hUZKYyAh19UUPESWeE50aEyg2u/7Qj5uUMg0uEohxOdxIrDX8FbU49o/LrDXYaY69AYq8/z7AlzfzsOf3yehDqKloaAHenlZDXcE9i6///++7WZUb9v9HB9+si1+3v0D+dnRKYAqhq3eBJrwmmQusN6YeWdz5mBMlHLiCAOeFOwmDG5AYzpG1PU3M4746WOfRnPp98irkfnUMdHf5Q8SWIqJ8qA8SNyA7zP/r3k/oVWJkl1K1CI/RGQOJtJeQsywe3BrDHfH48Gj1Ok74g8bq9Hop+2pi1t9ncG0l7zxB bpasanen@apigee.com'],
  }
  pe_accounts::user {'cwarren':
    comment => 'Craig Warren',
    groups  => ['admin', 'sudonopw'],
    uid     => '602',
    gid     => '602',
    sshkeys => ['ssh-dss AAAAB3NzaC1kc3MAAACBALJLzj4Ku6bdzAPWbdm52cC+kdxDs56/Ndn0SSCO8/o06J48IEnXVLU1W2X//xPwOkLULSKyDdw21OG8HelE6UnGfCeVQTGxIH10v8riZYz8vdX4UPb+mK/7R5b6aL9mmloq/C//WPpnoUFRLyLwFZIvKEOjDyQVg7kAToGxKyRjAAAAFQDNNGnCPGqGk8/F8tnoCSSPqiQMdwAAAIAbuaxCRYIap0QM5qWJJMAdEyDAUVfcqn3FR+bD1DumrUSZRS0fLXVYZvhC1WIU4jaNkuoMNg8E7HSAIFVJsprxYYM4TLi1cExdl/cXwK6+4COKAZUYutw3v3v3Bli2fteB0ZPRix4n9KndZKJUel2h0NeHQbjO13/XD6yLNHq3AAAAAIBAKclAgjhRukr6cJnlx0Jkdq8C41CVTXpfRVKFJ3LkPX5cafdhb8MdzfN9s9KCF4sNHHdwIX37Mosr/uQDfn3LLBsUeHZPAQr3rT7vKZoOQvmudLL/9BTUNhq/qVj+kKNXniIsyRQeR2zWY5YDwQmxpdCFMdYSt8wOyjPKhRaawg== Apigee@Craigs-MacBook-Pro.local'],
  }
  pe_accounts::user {'sudheer':
    comment => 'Sudheer Gopalam',
    groups  => ['admin', 'sudonopw'],
    uid     => '603',
    gid     => '603',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl57dVz4LNKdwPPwmnup9VbX3miYNUg11zDlCgwn1ZGvsP9RgovKnGDe9UhKj+cL876mQnlPxD76QeLqoenfr4VObwZ1O0l6R1i17+7GMPcdJMndTH0R2xqCR7qunvRSSe31IRSZVOhARoUx8gNZ/yZudBm4YrPbBqCHrCOPGnz7t73NQCUXg9M1Q9hPrfH44OY5jB0uYRcIP0PmlgWUmu+NhBaTAZHVvvckXfprb4oNnTieC8nXPXtO4eTcF4EbTSNT/WDJlsBrYU9kk6ZndA3WsnF1VSP5wIUOfvP1i+H48+P4sxtTbRURdRQcPLWfwFqv4H6zHVVsOLeHfVPQoN apigee@Sudheers-MacBook-Pro.local'],
  }
  pe_accounts::user {'jackson':
    comment => 'Jackson Chung',
    groups  => ['admin', 'sudonopw'],
    uid     => '604',
    gid     => '604',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqGYoySuyUWAl16k9+ZPOng+dUPVMHhfFDUaxyWUlz1rbIqmtAPUN9JvTbkRP97855YGh6NYH5F+czuUmjDyI5kygidsGviwCRTGy6JFvMZ968FT2hx3BPDjoDaWnFjSPNsVgeKcXlLLULItj5Ygbsa/VaetMqvE5nnB/1BVi2BpsXxq6DTrW/8Y1NLVvq9NwyhGmVEB/wnwAKhsIjjYcSQCiL0Gu5b0/PVXNnGUM2/ZUlrxe+Q6gH80Pj181mgdrfb7gR5XbZv0SADzwwQZdb/1RlPeknVmB7iUDMPcUVEzzsH7lDC/NVYcvAG1vT9aNZqmhU/qVolehpovcWT+25 jackson@faranth'],
  }
  pe_accounts::user {'ajit':
    comment => 'Ajith Jose',
    groups  => ['admin', 'sudonopw'],
    uid     => '605',
    gid     => '605',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA4RrQnnOrJJQo3FpSPke03fDADhtSbOkEMnPV8pBBhvM/Pr8j4n1fOetIEWAFbDp9djPhkxNVNY1Qm5Xqt24h971NrHVZxQ3leXbUwEI3+ZOhT0Dzc4L0/8Inxmqm0Srp5fI7vTTxYFA0KmxQ+29uNUNKTLHfUm5YSDNvPr8dfxzTZP3oryZNGONFYUeWmQO95c6oA8LInw2Ss0u5HkP8v9EAYieGjfaOpfbfYqcL729SVuM7WTNvM9lCVF7i5Zba4SN6Y8T2e7hb/e1USSmqAWh7tE4m0msiwA+N2zJKbCFD3qj4naZj6Ee9TUCL10v+V/CdVcOUFX7t4+kJ3W+VUw== ajose@apigee.com'],
  }
  pe_accounts::user {'hemana':
    comment => 'Hemana Gouda',
    groups  => ['admin', 'sudonopw'],
    uid     => '606',
    gid     => '606',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAo9jc+NbgLncKMxE34HO3u7kgZ19oxFMZ3Xt4i4QobZXVTiIe9vU+DbN3aa7XaWrPTAelqkUpnJUBL4YL2pua9hjQcU2RyyWwjxOXzAxmCREeTaUSevZunNzpXbRfRSlqLKXrXnRPgY6xnfJHZYGMbGRKVaFg0XSnTd6EgR0Hpo8t938bpmaBLfCP2XgEDC3jZvZWPqMermLR0+5ni+i5X/w6sHHi8kSwcWD2u9mJbqU0jTt0JYEXd2duBgkdw8NXVtQyiPPC0Xs4jtrBPfJ6t+v+/MBKMxmddasSrkRWB7uV+FNIfKF5R76kDb4zOQGH6TeHX5wKKrUaOa+OqjGkDQ== Hemana_key'],
  }
  pe_accounts::user {'maruthi':
    comment => 'Maruthi Chowdavarapu',
    groups  => ['admin', 'sudonopw'],
    uid     => '607',
    gid     => '607',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2UMEAuoj0uqUYzUZpFVaA2OX+xCupYRK72F/gZaUuGoczV0KIqdChn0ZuP9OGGyGqXrr0oCvcdEyciJTND169T/Au0MRQiJcne3Qi25cYyTza6WQWoRhuskMKAHDjnSpKhRHswG82nj4YIiBXGgY6mSEs5AQoWw+JzmdXNFdjL1FqEM77fbSzZyyOB7MtscS0NgXjPSNgkLS1orSgotZPxVri+Ei+a+msEG3dihUzGFj3+WXV6Mi1b7uWPlxafGdkruVLwI2/HN+hgO+lx2CwCUEV/Pco94p/78yPukLwETXpkQ2e6mj/VQNd/oaqaYNhtYLuvPQhkLlXa7oeSMhv maruthi@apigee.com'],
  }
  pe_accounts::user {'selvakumar':
    comment => 'Selvakumar Chockalingam',
    groups  => ['admin'],
    uid     => '608',
    gid     => '608',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAuyJQ91Ry5SvFDWh9PNrH1luEDqq7j5pVZilPlH1FixJFw79WajwoMuBc/JEJrTcjDdUBFlnw8udD8S8He4qRF84bTog1dzQuMkdghHAZ94VvL0eryc1QYFPXuffDfq2WMmlyJgE9Nux9HNt2uMPKApwbMtMUf9Y8OIlFwqISvk4AS2727l1Gz+b5cIljpg7rBgQhD6UZ6rsP2gPw8Kbwl6JEUikkW/tqkXc0loIE6dvN2DDQY8aHIzIa7eLGMOIhSyGSkvkw0CfqB43fS9HtXkukXfyjAxExzVqLGY63+uFteWEa1E1/qliozifQ5kU17jlUiGDdlyLHU8dLn4d/EQ== selva@client34.testlocal.com'],
  }
  pe_accounts::user {'sandeep':
    comment => 'Sandeep Bhojwani',
    groups  => ['admin', 'sudonopw'],
    uid     => '609',
    gid     => '609',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDplED26aDdENl9i9F74mnISqn0k657N8iSMtfRhhe6w5JMrT5quzsfQmaUD5HsX/9tfm7ef9d066R7jaSnXfje/IyvsKXP6f+66A3UPeESZHixrXEtXVqHNuJKthxloHSpKkS2hzmrPVmovwmgJqbx8C+NZQzjMMCyQHpM6yBEJs9INo6TxNqrOJt2Nf+FY+7zIvxh4tDlStakcb55Adzx/3PsNLdbHGRF5fIcEC8/ysmpoYV1lDlWcLpIIfE9p3WTwWvh48ZhiQcabJdUqcGYanGyaa6MNT3oIvRLt230ZItDb4itqmsqMpL54FVRwPgiqHdQWbmEMWY57bDPQp77 sbhojwani@apigee.com'],
  }
  pe_accounts::user {'sudarshan':
    comment => 'Sudarshan Jakka ',
    groups  => ['admin'],
    uid     => '610',
    gid     => '610',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJniTzw8tKo+kQ43OWTFwlljg0aQUxKZ4u1rWq25xbIVJ0J9HZVmDTG8PE0nXxPYLWSljlK9CaLS2PzQYYeFTufpQRMGeA6Vyb8j3NP4jnf3V+CF+99qC4ZoC/Qzo1VuTtcRgvKHvDZTvXth2KGGbS4Mar86fGtDBZY3MhdOQ5QkkGu9UhoMTKtcOvuqhWQNA5IOeTFg0vfGGXtEARTZ2BCkNLQBu0pNuoanKZUOGJyFgHDBJAo1qcIdO9XWbUNtxR4Urzq0YYIC42mHRFm469q281NKLOjjX3PULO0F6hWEgYKEmXS6D4plYWWW/SfpX9dUAd72L64tCmYS5ZVNkV sudarshan.ramakrishnaiah@gmail.com'],
  }
  pe_accounts::user {'basha':
    comment => 'Alur Basha',
    groups  => ['admin'],
    uid     => '611',
    gid     => '611',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkTHTrwMsjaWlApdIv2W3v4BhDGgB9HXYcO15SP0D8IhqkvAEeyxn3Yr6hSY6uNPdjn7gxifOvqaxMlXxMKU5lJc4jhaHtxNDrgD8jzStBrZYjQJU95HWGZG+fvD5aL1IfXvuYfwy5KHVpDJqewmtSSKBvHGbNLlmlL110v2o3kEkiYrxo/F4w6+YMBYjQu8+axugHx9MVKIlVYj7WREEgBpVF6AME9cZGEgGYIy8JqNP4JuOkG6Nhp3qh6Ub5b+nG9bNOEA2nKx5hCtdLUW7PVCJ5ZNsogqJfZQwrFNGCIDq3+NzkixpnvNeSkM8RQAn6ixjE+iF2epsJ/HAB0jOX alurbasha@apigee.com'],
  }
  pe_accounts::user {'af8335':
    comment => 'Tony (Anthony Faoro II)',
    groups  => ['admin', 'sudonopw'],
    uid     => '612',
    gid     => '612',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAmmtcHvYngWRpoj4T4+NGytE7DfuLbcOzz4yZDVb4YuQIdIPy7YOhzdS5cgHJkzVWTTqk97cHekQSO8nRpkkZKb1DK808svrYILWdA3IeGRcdgiHhQjwqNUOPhfwXXGXfzitemtpgcmc8nJTauCN0QM4BPbJ39OilsN6791kCjKuHuyMWoWkikFv5BsC5HO61H11hj9h8zQK/bPUqax86ReXbF1Z/tu+SH/xq7L6eMZuRhn6SfFOFRN4IKmM8BdLu5KKPPKD0ZmxGpqL1gOJhDr9xKnGL6O1mXt9JtRgJpA4YhS69YX9Xd6sv1vP77jotezMPog6iZsv72Pcu0uwDuw== af8335@att.com'],
  }
  pe_accounts::user {'mz407f':
    comment => 'Zak (Michael Zakharoff)',
    groups  => ['admin', 'sudonopw'],
    uid     => '613',
    gid     => '613',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA7bc8eqxqZZqgDv1Ft2THstTBikElo8Nc8AjQcRRBwpOW8oWwOmunzdcUbZb+HM6wzKETxXxA+uQY/AFu+1L+CWsZqdUQkDdGwJy1EY0XUB5NFkjY92IDIgNMGVUMi6+FKHoVFnKqjm59hQjP09GHegj2xQbB7h76UUC8dQIyJRm9qqCvgffyQyU9u2+xb4bSFpvPj1JovrxfOdujUa/5gqIBM+1tP0m7zHIw+/VoJ5RNPIVjf641bfzTflc5juPe3xmILEwGokX+U9yuD5k3pZZgZX06fSG7eUZKX8GSd0gzThHfbpRZrttd+P+b4VeMZzJsIH1PzHNShLikZ5GGsw== mz407f@att.com'],
  }
  pe_accounts::user {'jeevak':
    comment => 'Jeevak Kasarkod',
    groups  => ['admin','sudonopw'],
    uid     => '615',
    gid     => '615',
    sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDCEjMIrVSDchLxTATZSmiixeUWcCpPXAlutHxfp5ynpg281XaeDCOTecxuzepwTR4AZi2+Xf3/aGrxngDFlrXa9CWLDKofS4kW5zrntdPPhvbxiRvzQgfgb6mwCiwjrNp+uKTWGGJiQ0Bifv6/OoCKVwq170QiIjhE9Snq0HnY6yrFn8+j3sXH/1KEaLO37uZKj2pS0wHYvTMt68QUmHR+IIJodcWLQ48hkjgXeRxABr41TsotZW3sGCZi5JIFT/WptU6y8lrdbKr1kE1rqOI135uS7vx7c6/iSmVFzQ/FhUGdAkindkA34cVt9ghcwZ5vm82n7+r7og+jT1Go3If ApigeeCorporation@Jeevaks-MacBook-Pro.local'],
  }
}
