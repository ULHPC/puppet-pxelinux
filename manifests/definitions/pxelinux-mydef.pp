# File::      <tt>pxelinux-mydef.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: pxelinux::mydef
#
# Configure and manage pxelinux
#
# == Pre-requisites
#
# * The class 'pxelinux' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# == Sample usage:
#
#     include "pxelinux"
#
# You can then add a mydef specification as follows:
#
#      pxelinux::mydef {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define pxelinux::mydef(
    $ensure         = 'present',
    $content        = '',
    $source         = ''
)
{
    include pxelinux::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("pxelinux::mydef 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($pxelinux::ensure != $ensure) {
        if ($pxelinux::ensure != 'present') {
            fail("Cannot configure a pxelinux '${basename}' as pxelinux::ensure is NOT set to present (but ${pxelinux::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => $source ? {
            ''      => template('pxelinux/pxelinux_entry.erb'),
            default => ''
        },
        default => $content
    }
    $real_source = $source ? {
        '' => '',
        default => $content ? {
            ''      => $source,
            default => ''
        }
    }

    # concat::fragment { "${pxelinux::params::configfile}_${basename}":
    #     target  => "${pxelinux::params::configfile}",
    #     ensure  => "${ensure}",
    #     content => $real_content,
    #     source  => $real_source,
    #     order   => '50',
    # }

    # case $ensure {
    #     present: {

    #     }
    #     absent: {

    #     }
    #     disabled: {

    #     }
    #     default: { err ( "Unknown ensure value: '${ensure}'" ) }
    # }

}



