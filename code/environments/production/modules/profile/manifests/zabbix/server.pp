class profile::zabbix::server {
  
  class { 'apache':
    mpm_module => lookup('profile::zabbix::server::apache_module'),
  }

  include apache::mod::php

  class { 'mysql::server': }

  class { 'zabbix':
    zabbix_url    => lookup('profile::zabbix::server::url'),
    database_type => lookup('profile::zabbix::server::db_type'),
  }

  class { 'zabbix::agent':
    server => lookup('profile::zabbix::server::server_ip_agt'),
  }
}
