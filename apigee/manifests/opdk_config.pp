#/etc/puppetlabs/puppet/modules/apigee/manifests/opdk_config.pp
# This is the opdk config class which the service class depends on. It encapsulates
# apigee-install.sh, apigee-setup.sh, and might even call stuff for onboarding
# if I can figure out how to write it neatly

class apigee::opdk_config inherits apigee {
  $opdk_bin = "apigee-gateway-$my_opdk_version.zip"
  $opdk_license_file = hiera('apigee_license_file')
  $opdk_root_dir = "${derived_mnt_dir}"
  $opdk_data_dir = "${derived_mnt_dir}"
  $opdk_install_answers_file = ""
  $opdk_setup_answers_file = ""
  
  # Place the files in the right place
  # If role == mgmt, place the license file
  if $role == 'mgmt' {
    file { 'apigee_opdk_license':
      owner  => $apigee_user,
      group  => $apigee_user,
      path   => $opdk_license_file,
      ensure => file,
      mode   => '0777',
      source => "puppet:///modules/apigee/license.txt",
    }
  }

  # Place the install answers file in $my_mnt_dir
  file { 'apigee_opdk_install_answers':
    owner  => $apigee_user,
    group  => $apigee_group,
    path   => $my_mnt_dir/apigee_opdk_install_answers.txt,
    ensure => file,
    mode   => '0777',
    source => "puppet:///modules/apigee/apigee_opdk_install_answers.erb"
  }

  # Place the setup answers file in $my_mnt_dir
  file { 'apigee_opdk_setup_answers':
    owner  => $apigee_user,
    group  => $apigee_group,
    path   => $my_mnt_dir/apigee_opdk_setup_answers.txt,
    ensure => file,
    mode   => '0777',
    source => "puppet:///modules/apigee/apigee_opdk_setup_answers.erb"
  }

# The OPDK binary
#    file { 'apigee_opdk_file':
#      owner   => "apigee",
#      group   => "apigee",
#      path    => "$my_mnt_dir/$opdk_bin",
#      ensure  => present,
#      mode    => '0777',
#      source  => "puppet:///modules/apigee/$opdk_bin",
#      backup  => false,
#    }

# If apigee-setup has not been run, run it.
# profile values are in hiera as opdk_profile_types: 'aio,ds,is,mp,ms,ps,qis,qs,r,rmp,sa,sax'
 
# apigee-setup.sh usage() {
#  echo "Usage: $(basename $0) [ -h | [-p profile] [-f <filename>]]"
#  echo "  -h | --help : Display usage information"
#  echo "  -p | --profile <profile> : aio,ds,is,mp,ms,ps,qis,qs,r,rmp,sa,sax"
#  echo "  -f | --file <filename> : Use defaults from <filename>"
#  exit 1
}
