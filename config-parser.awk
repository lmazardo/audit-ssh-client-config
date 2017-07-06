#!/usr/bin/awk -f
function is_in_array(item, array) {
  is_present = 0
  for (i in array) {
    if (item == array[i]) { is_present = 1 }
  }
  return is_present
}

BEGIN {
  host = "*"
  hosts[1] = host
  count = 2
}

$1 == "Host" {
  host = $2

  # Do not duplicate host entries
  if (!is_in_array(host, hosts)) {
    hosts[count] = host
  }

  count++
}

$1 == "PasswordAuthentication" ||
$1 == "ChallengeResponseAuthentication" ||
$1 == "HostKeyAlgorithms" ||
$1 == "KexAlgorithms" ||
$1 == "Ciphers" ||
$1 == "PubkeyAuthentication" ||
$1 == "MACs" ||
$1 == "UseRoaming" {
  # When we start a new file, raw parameters are affected to "Host *"
  if (NR != FNR && FNR == 1) { host = "*" }

  # Do not override a value that has aleardy been set
  if (hosts_params[host, $1] == "") {
    hosts_params[host, $1] = $2
  }
}

END {
  for (host in hosts) {
    host_value = hosts[host]

    if (host_value == "*") {
      level="ERROR"
    } else {
      level="WARNING"
    }

    split("PasswordAuthentication ChallengeResponseAuthentication PubkeyAuthentication UseRoaming KexAlgorithms Ciphers HostKeyAlgorithms MACs", parameters)

    expected_kex_algorithms = "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256"
    expected_ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
    expected_host_key_algorithms = "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa"
    expected_macs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com"
    split("no no yes no", expected_values)
    expected_values[5] = expected_kex_algorithms
    expected_values[6] = expected_ciphers
    expected_values[7] = expected_host_key_algorithms
    expected_values[8] = expected_macs

    for (i in parameters) {
      parameter_name = parameters[i]
      parameter_value = hosts_params[host_value, parameter_name]
      expected_value = expected_values[i]

      if (parameter_value == "" && host_value == "*") {
        printf "%s: %s is missing for host %s\n", level, parameter_name, host_value
      } else if (parameter_value != "" && parameter_value != expected_value) {
        printf "%s: %s should be set to '%s' for host %s\n", level, parameter_name, expected_value, host_value
      }
    }
  }
}
