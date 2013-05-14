require 'facter'
Facter.add(:apigee_run_dir) do
  setcode do
    "< %= mnt_dir %>/apigee-4.20.0"
  end
end
