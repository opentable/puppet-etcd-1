# == Class etcd::service
#
class etcd::service {
  # Switch service details based on osfamily

  if $::osfamily != 'Debian' {
    fail("OSFamily ${::osfamily} not supported.")
  }

  # Create the appropriate service file
  if $etcd::manage_service_file {
    file { 'etcd-servicefile':
      ensure  => file,
      path    => '/etc/init/etcd.conf',
      owner   => $etcd::user,
      group   => $etcd::group,
      mode    => '0444',
      content => template('etcd/etcd.init.erb'),
      notify  => Service['etcd'],
    }
  }

  # Set service status
  service { 'etcd':
    ensure   => $etcd::service_ensure,
    enable   => $etcd::service_enable,
    provider => 'upstart',
  }
}
