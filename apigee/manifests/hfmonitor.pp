#/etc/puppetlabs/puppet/modules/apigee/manifests/hfmonitor.pp
# This is for turning monitoring required by ATT on or off. It coordinates with
# Chef for when to turn on or off this particular monitoring via a file stored
# in /tmp called nohfmonitor
class apigee::hfmonitor inherits apigee {
  $file = "${my_root_dir}/share/apigee/bin/start"
# nohup $JAVA -classpath "$classpath" -Xms$min_mem -Xmx$max_mem -XX:MaxPermSize=$max_permsize -Dinstallation.dir=$install_dir $sys_props -Dconf.dir=$conf_path -Ddata.dir=$data_dir $* com.apigee.kernel.MicroKernel &
# nohup $JAVA -classpath "$classpath" -Xms$min_mem -Xmx$max_mem -XX:MaxPermSize=$max_permsize -Dinstallation.dir=$install_dir $sys_props -Dconf.dir=$conf_path -Ddata.dir=$data_dir $* com.apigee.kernel.MicroKernel >/mnt/apigee4/var/log/apigee/stdout.log &
  $pattern = "nohup .* com.apigee.kernel.MicroKernel"
  $appendstr = ">${my_root_dir}/var/log/apigee/stdout.log"
# Insert log collection
  exec { 'apigee_generic_start_io_redirect_on': 
# sed --in-place='' --expression='s|^\(nohup .* com.apigee.kernel.MicroKernel\) \&$|& >/mnt/apigee4/var/log/apigee/stdout.log \&|' $file
    command => "sed --in-place='' --expression='s|^\(${pattern}\) \(\&\)|\1 ${appendstr} \2|' ${file}",
    unless  => "test -f /tmp/nohfmonitor && ! grep -e \"${appendstr}\" ${file}",
    path    => "/bin:/usr/bin:/usr/local/bin",
  }
# Remove log collection
  exec { 'apigee_generic_start_io_redirect_off':
    command => "sed --in-place='' --expression='s|${appendstr} ||' ${file}",
    unless  => "test ! -f /tmp/nohfmonitor && grep -e \"${appendstr}\" ${file}",
    path    => "/bin:/usr/bin:/usr/local/bin",
  }

  notify { "hfmonitoring":
    withpath => "true",
    name     => "file is ${file} , appendstr is ${appendstr} , pattern is ${pattern}",
  }
}
