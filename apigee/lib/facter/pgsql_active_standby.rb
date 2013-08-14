require 'facter'
require 'net/http'

#Facter.add(:pgsql_active_or_standby) do
#  local_ip=Facter.value('ipaddress')
# Need to lookup this value in hiera instead of setting it here
#  local_pgsql_port=hiera('pgsql_port') 
#  local_pgsql_port="8084"
#  local_role=Facter.value('role')
#  if /pgsql/.match( local_role )
#    setcode do
#      res=Net::HTTP.get(URI.parse("http://#{local_ip}:#{local_pgsql_port}/v1/servers/self/state"))
#      return_val=res.tr('"','')
      #puts "Calling v1/servers/self/state - #{return_val}"
#    end
#  end
#end
