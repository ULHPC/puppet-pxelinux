# File::      <tt>pxelinux-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: pxelinux::params
#
# In this class are defined as variables values that are used in other
# pxelinux classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class pxelinux::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of pxelinux
    $ensure = $pxelinux_ensure ? {
        ''      => 'present',
        default => "${pxelinux_ensure}"
    }

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # pxelinux packages
    $packagename = $::operatingsystem ? {
        default => 'syslinux',
    }

    # root directory
    $root_dir    = '/srv/tftp/'

    $pxelinux_file = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => '/usr/lib/syslinux/pxelinux.0',
        /(?i-mx:centos|fedora|redhat)/ => '/usr/share/syslinux/pxelinux.0',
        default => '/usr/lib/syslinux/pxelinux.0',
    }
    $config_file = $::operatingsystem ? {
        default => 'default',
    }
    $pxe_mode = $::operatingsystem ? {
        default => '755',
    }
    $pxe_owner = $::operatingsystem ? {
        default => 'root',
    }
    $pxe_group = $::operatingsystem ? {
        default => 'root',
    }

}

