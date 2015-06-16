# File::      <tt>pxelinux.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: pxelinux::common
#
# Base class to be inherited by the other pxelinux classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class pxelinux::common {

    # Load the variables used in this module. Check the pxelinux-params.pp file
    require pxelinux::params

    package { 'pxelinux':
        ensure => $pxelinux::ensure,
        name   => $pxelinux::params::packagename,
    }


    if (! defined(File[$pxelinux::root_dir])) {
      file { $pxelinux::root_dir:
          ensure => 'directory',
          path   => $pxelinux::root_dir,
          owner  => $pxelinux::params::pxe_owner,
          group  => $pxelinux::params::pxe_group,
          mode   => $pxelinux::params::pxe_mode,
      }
      File[$pxelinux::root_dir] -> File["${pxelinux::root_dir}/pxelinux.cfg"] -> Exec['hardlink_pxelinux.0']
    }

    file { "${pxelinux::root_dir}/pxelinux.cfg":
        ensure => 'directory',
        owner  => $pxelinux::params::pxe_owner,
        group  => $pxelinux::params::pxe_group,
        mode   => $pxelinux::params::pxe_mode,
    }
    exec { 'hardlink_pxelinux.0':
        command => "ln ${pxelinux::params::pxelinux_file} ${pxelinux::root_dir}/pxelinux.0",
        path    => '/usr/bin:/bin:/sbin',
        creates => "${pxelinux::root_dir}/pxelinux.0",
        user    => $pxelinux::params::pxe_owner,
        require => Package['pxelinux'],
    }

    if ($pxelinux::source != '')
    {
        file { 'pxelinux.conf':
            ensure  => $pxelinux::ensure,
            path    => "${pxelinux::root_dir}/pxelinux.cfg/${pxelinux::params::config_file}",
            owner   => $pxelinux::params::pxe_owner,
            group   => $pxelinux::params::pxe_group,
            mode    => $pxelinux::params::pxe_mode,
            source  => $pxelinux::source,
            require => File["${pxelinux::root_dir}/pxelinux.cfg"]
        }
    }

}
