class nginx {
  package { 'nginx':
    ensure   => installed,
    }
  notify { 'nginx is installed':
  }
  service { 'nginx':
    ensure   => running,
  }
 }
