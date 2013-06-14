require 'facter'
Facter.add(:apigee_run_dir) do
  setcode do
    $mnt_dir = hiera('mnt_dir')
    $version = hiera('opdk_run_version')
    $return_var = [$mnt_dir, $opdk_run_version].join("/apigee-")
  end
end
