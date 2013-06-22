require 'facter'

local_hostname = Facter.value('hostname')
array = local_hostname.split("-")
rn = array[2].scan(/\d+/).first

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

Facter.add(:rolenumber) do
  setcode do
    rn
  end
end

Facter.add(:role) do
  setcode do
    array[2].delete( rn )
  end
end

