require 'facter'
Facter.add(:system_role) do
  setcode do
    role = Facter::Util::Resolution.exec("hostname -s")
    role
  end
end
