# This class takes a hash of repos and ensures they are present on a node

class yumrepos
(
  $defaults   = $yumrepos::params::defaults,
  $repos      = $yumrepos::params::repos,
  $hiera_hash = $yumrepos::params::hiera_hash,
  $purge      = $yumrepos::params::purge,
  $keysource  = $yumrepos::params::keysource,
  $keydir     = $yumrepos::params::keydir
) inherits yumrepos::params {

  # Ensure we are operating on a booleans

  validate_bool($hiera_hash, $purge)

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

  resources { 'yumrepo':
    purge => $purge,
  }

  # Ensure keys are present
  # No import exec is performed as the puppet yum proivder runs with the '-y'
  # flag so keys are automatically accepted anyway

  file { $keydir:
  ensure  => directory,
  purge   => $purge,
  recurse => true,
  force   => true,
  owner   => 'root',
  group   => 'root',
  source  => $keysource
  }

}

