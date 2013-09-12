#/etc/puppetlabs/puppet/modules/apigee/manifests/share_apigee_bin_start.pp
# This is the class definition for the start file. It is a parameterized class.
class apigee::share_apigee_bin_start ($conf) inherits apigee {
# $conf = /mnt/apigee4/share/apigee/bin/start2
#  $jvm_opts = "-server –d64 -Xms3g -Xmx3g -XX:PermSize=800m -XX:MaxPermSize=800m -XX:NewSize=1g -XX:MaxNewSize=1g -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -verbose:gc -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:-UseBiasedLocking -XX:ParallelGCThreads=12 -XX:LargePageSizeInBytes=128m"
#  $orig_line = 'nohup $JAVA -classpath "$classpath" -Xms$min_mem -Xmx$max_mem -XX:MaxPermSize=$max_permsize -Dinstallation.dir=$install_dir $sys_props -Dconf.dir=$conf_path -Ddata.dir=$data_dir $* com.apigee.kernel.MicroKernel &'
#  $replace_line = "# ${orig_line} \nnohup $JAVA -classpath \"$classpath\" ${jvm_opts} -Dinstallation.dir=$install_dir $sys_props -Dconf.dir=$conf_path -Ddata.dir=$data_dir $* com.apigee.kernel.MicroKernel &"

#  file_line { "apigee-share-apigee-bin-start_jvm-tuning":
#   ensure => present,
#   match => "^${orig_line}.*$",
#   line => "${replace_line}",
#   path => "${conf}",
#  }
  file { "apigee-share_apigee_bin_start":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    path    => "${conf}",
    content => template('apigee/apigee-share_apigee_bin_start.erb'),
  }
  notify { "Running on a ${role}, file is ${conf}": 
    withpath => true,
  }
}
