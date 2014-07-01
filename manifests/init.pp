# This class takes a hash of repos and ensures they are present on a node

class yumrepos
(
$defaults   = { ensure => present, enabled => '1' },
$repos      = undef,
$hiera_hash = false,
)

{

  # Ensure we are operating on a boolean

  validate_bool($hiera_hash)

  # If hiera is used as an ENC the $repos parameter it will only be
  # defined as the first matching value. As such check if the user wants
  # a hash across hierarchies and define variable in the manifest.
  #
  # $yumrepos is used as an interim as puppet does not allow us to
  # reassign variables

  if $hiera_hash == true {
    $yumrepos = hiera_hash('yumrepos::repos')
  }
  else {
    $yumrepos = $repos
  }

  # Ensure we are operating on a hash.

  validate_hash($defaults, $yumrepos)

  create_resources(yumrepo, $yumrepos, $defaults)

  # Ensure keys are present
  # No import exec is performed as the puppet yum proivder runs with the '-y'
  # flag so keys are automatically accepted anyway

  file { '/etc/pki/rpm-gpg':
  ensure  => directory,
  recurse => true,
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///modules/yumrepos/'
  }

}

