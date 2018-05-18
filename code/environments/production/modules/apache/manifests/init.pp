class db {
  include '::mysql::server'
  mysql::db { 'test_mdb' :
    user => 'test_user',
    password => 'password',
    host => 'localhost',
    grant => ['CREATE', 'SELECT', 'UPDATE', 'DROP'],
  }
}

class apache {

  case $osfamily {

    'Ubuntu', 'Debian': {
      include apache2
      apache2::vhost { 'ubuntusite1.com':
        site_name => 'ubuntusite1.com',
        }

    }
    'Redhat','CentOS': {
      include httpd
      httpd::vhost { 'centossite1.com':
        site_name => 'centossite1.com',
        }
    }

  }

}

class httpd {
  service {'httpd':
    ensure => running,
    enable => true,
    require => Package['httpd'],
  }
  package {'httpd':
    ensure => installed,
  }
}
class apache2 {
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
  package { 'apache2':
    require => Exec['apt-update'],
    ensure => installed,
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    require => Package['apache2'],
  }
}

define httpd::vhost ($site_name='centossiteN.com') {
  file {"/etc/httpd/conf.d/$site_name.conf":
    content => "<VirtualHost *:80>\n\tServerName $site_name\n\tDocumentRoot /var/www/$site_name\n</VirtualHost>\n",
    notify  => Service['httpd'],
  }

  file {"/var/www/$site_name":
    ensure  => directory,
  }

  file {"/var/www/$site_name/index.html":
    content => "<html><h1>$osfamily test page $site_name</h1></html>\n",
   }
  }

define apache2::vhost ($site_name='ubuntusiteN.com') {
  file {"/etc/apache2/conf-enabled/$site_name.conf":
    content => "<VirtualHost *:80>\n\tServerName $site_name\n\tDocumentRoot /var/www/$site_name\n</VirtualHost>\n",
    notify  => Service['apache2'],
  }

  file {"/var/www/$site_name":
    ensure  => directory,
  }

  file {"/var/www/$site_name/index.html":
    content => "<html><h1>$osfamily test page $site_name</h1></html>\n",
   }
  }

