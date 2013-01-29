# File::      <tt>pxelinux.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: pxelinux
#
# Configure and manage pxelinux
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of pxelinux
# $source:: *Default*: empty. Source file for the default config file
# $root_dir:: *Default*: '/srv/tftp'. Root directory for your tftp server
#
# == Actions:
#
# Install and configure pxelinux
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import pxelinux
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'pxelinux':
#             ensure    => present,
#             source    => 'puppet:///modules/pxelinux/viridis-default',
#             root_dir  => '/srv/tftp'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class pxelinux(
    $ensure    = $pxelinux::params::ensure,
    $root_dir  = $pxelinux::params::root_dir,
    $source    = ''
)
inherits pxelinux::params
{
    info ("Configuring pxelinux (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("pxelinux 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include pxelinux::debian }
        redhat, fedora, centos: { include pxelinux::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

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
        name    => "${pxelinux::params::packagename}",
        ensure  => "${pxelinux::ensure}",
    }


    file { "root_dir_${pxelinux::root_dir}":
        ensure => 'directory',
        path   => "${pxelinux::root_dir}",
        owner  => "${pxelinux::params::pxe_owner}",
        group  => "${pxelinux::params::pxe_group}",
        mode   => "${pxelinux::params::pxe_mode}",
    }
    file { "${pxelinux::root_dir}/pxelinux.cfg":
        ensure => 'directory',
        owner  => "${pxelinux::params::pxe_owner}",
        group  => "${pxelinux::params::pxe_group}",
        mode   => "${pxelinux::params::pxe_mode}",
        require => File["root_dir_${pxelinux::root_dir}"]
    }
    exec { 'hardlink_pxelinux.0':
        command => "ln ${pxelinux::params::pxelinux_file} ${pxelinux::root_dir}/pxelinux.0",
        path    => '/usr/bin:/bin:/sbin',
        creates => "${pxelinux::root_dir}/pxelinux.0",
        user    => "${pxelinux::params::pxe_owner}",
        require => [ Package['pxelinux'],
                     File["root_dir_${pxelinux::root_dir}"]
                   ]
    }

    if ($source != '')
    {
        file { 'pxelinux.conf':
            ensure  => "${pxelinux::ensure}",
            path    => "${pxelinux::root_dir}/pxelinux.cfg/${pxelinux::params::config_file}",
            owner   => "${pxelinux::params::pxe_owner}",
            group   => "${pxelinux::params::pxe_group}",
            mode    => "${pxelinux::params::pxe_mode}",
            source  => "${pxelinux::source}",
            require => File["${pxelinux::root_dir}/pxelinux.cfg"]
        }
    }

}


# ------------------------------------------------------------------------------
# = Class: pxelinux::debian
#
# Specialization class for Debian systems
class pxelinux::debian inherits pxelinux::common { }

# ------------------------------------------------------------------------------
# = Class: pxelinux::redhat
#
# Specialization class for Redhat systems
class pxelinux::redhat inherits pxelinux::common { }



