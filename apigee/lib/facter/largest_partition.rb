require 'facter'

Facter.add(:derived_mnt_dir) do
  setcode do
		Facter::Util::Resolution.exec("grep `sfdisk -s | egrep -v total | sort -rn | head -1 | awk -F':' '{ print $1 }'` /proc/mounts | awk '{ print $2 }'")
	end
end