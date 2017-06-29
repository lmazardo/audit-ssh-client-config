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


    if (kex_algorithms_values == "" && host_value == "*") {
      printf "%s: KexAlgorithms are missing for host %s\n", level, host_value
    }
    split(kex_algorithms_values, kex_algorithms, ",")
    for (i in kex_algorithms) {
      if (kex_algorithms[i] != "curve25519-sha256@libssh.org" &&
          kex_algorithms[i] != "diffie-hellman-group-exchange-sha256") {
        printf "%s: KexAlgorithms '%s' should be avoided for host %s\n", level, kex_algorithms[i], host_value
      }
    }

    if (ciphers_values == "" && host_value == "*") {
      printf "%s: Ciphers are missing for host %s\n", level, host_value
    }
    split(ciphers_values, ciphers, ",")
    for (i in ciphers) {
      if (ciphers[i] != "chacha20-poly1305@openssh.com" &&
          ciphers[i] != "aes256-gcm@openssh.com" &&
          ciphers[i] != "aes128-gcm@openssh.com" &&
          ciphers[i] != "aes256-ctr" &&
          ciphers[i] != "aes192-ctr" &&
          ciphers[i] != "aes128-ctr") {
        printf "%s: Ciphers '%s' should be avoided for host %s\n", level, ciphers[i], host_value
      }
    }

    if (host_key_algorithms_values == "" && host_value == "*") {
      printf "%s: HostKeyAlgorithms are missing for host %s\n", level, host_value
    }
    split(host_key_algorithms_values, host_key_algorithms, ",")
    for (i in host_key_algorithms) {
      if (host_key_algorithms[i] != "ssh-ed25519-cert-v01@openssh.com" &&
          host_key_algorithms[i] != "ssh-rsa-cert-v01@openssh.com" &&
          host_key_algorithms[i] != "ssh-ed25519" &&
          host_key_algorithms[i] != "ssh-rsa") {
        printf "%s: HostKeyAlgorithms '%s' should be avoided for host %s\n", level, host_key_algorithms[i], host_value
      }
    }

    if (macs_values == "" && host_value == "*") {
      printf "%s: MACs are missing for host %s\n", level, host_value
    }
    split(macs_values, macs, ",")
    for (i in macs) {
      if (macs[i] != "hmac-sha2-512-etm@openssh.com" &&
          macs[i] != "hmac-sha2-256-etm@openssh.com" &&
          macs[i] != "hmac-ripemd160-etm@openssh.com" &&
          macs[i] != "umac-128-etm@openssh.com" &&
          macs[i] != "hmac-sha2-512" &&
          macs[i] != "hmac-sha2-256" &&
          macs[i] != "hmac-ripemd160" &&
          macs[i] != "umac-128@openssh.com") {
        printf "%s: MACs '%s' should be avoided for host %s\n", level, macs[i], host_value
      }
    }
  }
}
