class yumrepos::params {
  $defaults   = { enabled => '1' }
  $repos      = undef
  $hiera_hash = false
  $purge      = false
  $keysource  = 'puppet:///modules/yumrepos/'
  $keydir     = '/etc/pki/rpm-gpg'
}
