#!/usr/bin/awk -f

BEGIN {
  count = 1
}

$1 == "Host" {
  host = $2

  hosts[count] = host
  hosts_params[host] = ""

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
  hosts_params[host, $1] = $2
}

END {
  for (host in hosts) {
    host_value = hosts[host]

    if (host_value == "*") {
      level="ERROR"
    } else {
      level="WARNING"
    }


    # These parameters can take boolean values ('yes' or 'no')
    split("PasswordAuthentication ChallengeResponseAuthentication PubkeyAuthentication UseRoaming", boolean_parameters)
    split("no no yes no", expected_values)
    for (i in boolean_parameters) {
      boolean_parameter = boolean_parameters[i]
      parameter_value = hosts_params[host_value, boolean_parameter]
      expected_value = expected_values[i]

      if (parameter_value == "" && host_value == "*") {
        printf "%s: %s is missing for host %s\n", level, boolean_parameter, host_value
      } else if (parameter_value != "" && parameter_value != expected_value) {
        printf "%s: %s is set to '%s' for host %s\n", level, boolean_parameter, parameter_value, host_value
      }
    }


    # These parameters can take list of values, separated by a coma ','
    kex_algorithms_values = hosts_params[host_value, "KexAlgorithms"]
    ciphers_values = hosts_params[host_value, "Ciphers"]
    host_key_algorithms_values = hosts_params[host_value, "HostKeyAlgorithms"]
    macs_values = hosts_params[host_value, "MACs"]


    expected_kex_algorithms = "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256"
    if (kex_algorithms_values == "" && host_value == "*") {
      printf "%s: KexAlgorithms is missing for host %s\n", level, host_value
    } else if (kex_algorithms_values != "" && kex_algorithms_values != expected_kex_algorithms) {
      printf "%s: KexAlgorithms should be set to '%s' for host %s\n", level, expected_kex_algorithms, host_value
    }

    expected_ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
    if (ciphers_values == "" && host_value == "*") {
      printf "%s: Ciphers is missing for host %s\n", level, host_value
    } else if (ciphers_values != "" && ciphers_values != expected_ciphers) {
      printf "%s: Ciphers should be set to '%s' for host %s\n", level, expected_ciphers, host_value
    }

    expected_host_key_algorithms = "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa"
    if (host_key_algorithms_values == "" && host_value == "*") {
      printf "%s: HostKeyAlgorithms is missing for host %s\n", level, host_value
    } else if (host_key_algorithms_values != "" && host_key_algorithms_values != expected_host_key_algorithms) {
      printf "%s: HostKeyAlgorithms should be set to '%s' for host %s\n", level, expected_host_key_algorithms, host_value
    }

    expected_macs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com"
    if (macs_values == "" && host_value == "*") {
      printf "%s: MACs is missing for host %s\n", level, host_value
    } else if (macs_values != "" && macs_values != expected_macs) {
      printf "%s: MACs should be set to '%s' for host %s\n", level, expected_macs, host_value
    }
  }
}
