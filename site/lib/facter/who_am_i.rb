require 'facter'

local_hostname = Facter.value('hostname')
array = local_hostname.split("-")

Facter.add(:function) do
  setcode do
    array[0]
  end
end

Facter.add(:env) do
  setcode do
    array[1]
  end
end

Facter.add(:role) do
  setcode do
    array[2]
  end
end

Facter.add(:rolenumber) do
  setcode do
    array[2]
  end
end
