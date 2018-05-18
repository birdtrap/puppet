class profile::zabbix::agent {
  class { 'zabbix::agent':
    server => lookup('profile::zabbix::agent::server_ip'),
  }

  include my_zabbix_agent
}
