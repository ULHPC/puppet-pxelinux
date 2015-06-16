# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'pxelinux::params'

$names = ['ensure', 'packagename', 'root_dir', 'pxelinux_file', 'config_file', 'pxe_mode', 'pxe_owner', 'pxe_group']

notice("pxelinux::params::ensure = ${pxelinux::params::ensure}")
notice("pxelinux::params::packagename = ${pxelinux::params::packagename}")
notice("pxelinux::params::root_dir = ${pxelinux::params::root_dir}")
notice("pxelinux::params::pxelinux_file = ${pxelinux::params::pxelinux_file}")
notice("pxelinux::params::config_file = ${pxelinux::params::config_file}")
notice("pxelinux::params::pxe_mode = ${pxelinux::params::pxe_mode}")
notice("pxelinux::params::pxe_owner = ${pxelinux::params::pxe_owner}")
notice("pxelinux::params::pxe_group = ${pxelinux::params::pxe_group}")

#each($names) |$v| {
#    $var = "pxelinux::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
