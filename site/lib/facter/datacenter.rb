require 'facter'
Facter.add(:datacenter) do
  setcode do
    Facter::Util::Resolution.exec("hostname -d")
  end
end
