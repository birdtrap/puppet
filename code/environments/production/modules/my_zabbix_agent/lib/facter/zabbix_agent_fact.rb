Facter.add('is_installed') do
  setcode do
    if File.exist? '/tmp/curl_connect'
      'true'
    else
      'false'
    end
  end
end

