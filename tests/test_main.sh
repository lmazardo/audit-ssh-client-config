#!/bin/bash

source ./test_password_authentication
source ./test_challenge_response_authentication
source ./test_host_key_algorithms
source ./test_kex_algorithms
source ./test_ciphers
source ./test_pubkey_authentication
source ./test_macs


test_each_message_is_displayed_only_once() {
  cat << __EOF__ >"fake_bad_config"
Host *
__EOF__

  ../main fake_bad_config > result

  # PasswordAuthentication, ChallengeResponseAuthentication, HostKeyAlgorithms
  # KexAlgorithms, Ciphers, PubkeyAuthentication, MACs
  # are missing and therefore trigger an error
  assert_equals 7 "$(grep -c ERROR result)"
}


teardown() {
  rm fake*
  rm result*
}
