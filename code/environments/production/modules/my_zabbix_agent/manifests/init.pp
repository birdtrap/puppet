# class agent
class my_zabbix_agent{
  file { '/tmp/curl_connect':
    ensure  => file,
    content => template('my_zabbix_agent/curl_connect.erb'),
  }

  file { '/tmp/curl_token':
    ensure  => file,
    content => template('my_zabbix_agent/curl_token.erb'),
  }

  package{ 'jq':
    ensure => 'installed',
  }


  if $facts['is_installed'] == false
  {
    exec{ 'add host':
      path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
      command => 'echo $(curl -i -k -X  POST -H "Content-Type: application/json-rpc" -T /tmp/curl_token http://zabbix.example.com/api_jsonrpc.php | grep result | jq .result)} >> /tmp/curl_connect;\
      curl -i -k -X  POST -H "Content-Type: application/json-rpc" -T /tmp/curl_connect http://zabbix.example.com/api_jsonrpc.php',
    }
  }
}
