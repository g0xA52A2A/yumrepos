yumrepos puppet module
======================

About
-----

I was sick of having modules for various repos and module dependencies for yet
another EPEL module.

This has a dependency on the puppetlabs/stdlib for validation checks.

Simply throw the $repos parameter a nested hash of repos
and stop writing yumrepo modules.

If the $heria_hash parameter is true values for $repos across all hierarchies
are used so repos can be defined at multiple levels.
This allows for a base set of repos to be defined at a low level of the
hierarchy and more specific repos to be defined further up the hierarchy
closer to what is likely more relevant definitions.

There is also a $defaults parameter intended to minimise boiler plate.
This enables default attributes to be set once and applied for all puppet
defined yumrepos. In this module this is set to ensure the repo is enabled.
Handy if you have to proxy all your repos or something for example.

If the attribute is defined in both $repos and $defaults the value in
$repos takes precedence.

Usage
-----

Include the class

```puppet
include yumrepos
```

Pass the class a nested hash of repos

```puppet
$repos = {
  epel => {
  descr     => 'Extra Packages for Enterprise Linux 6 - x86_64',
  baseurl   => 'http://download.fedoraproject.org/pub/epel/6/$basearch',
  gpgkey    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
  priority  => '10',
  }
  myrepo => {
  descr     => 'Local mirror of Foo',
  baseurl   => 'http://foo.server.com/6/$basearch',
  gpgkey    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-foo',
  priority  => '10',
  }
}
```

Set all repos to check gpgkeys

```puppet
$defaults = {
  ensure    => present,
  enabled   => true,
  gpgcheck  => true,
}
```

You can provide keys by dropping them into the files directory of this module

