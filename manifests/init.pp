# File::      <tt>init.pp</tt>
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
        debian, ubuntu:         { include pxelinux::common::debian }
        redhat, fedora, centos: { include pxelinux::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}
