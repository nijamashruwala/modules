require 'facter'
Facter.add(:system_role) do
  setcode do
    Facter::Util::Resolution.exec("hostname -s")
  end
end
