#!/bin/bash

source ./test_password_authentication
source ./test_challenge_response_authentication
source ./test_kex_algorithms
source ./test_ciphers
source ./test_pubkey_authentication


test_each_message_is_displayed_only_once() {
  cat << __EOF__ >"fake_bad_config"
Host *
__EOF__

  ../main fake_bad_config > result

  # PasswordAuthentication, ChallengeResponseAuthentication,
  # KexAlgorithms, Ciphers, PubkeyAuthentication
  # are missing and therefore trigger an error
  assert_equals 5 "$(grep -c ERROR result)"
}


teardown() {
  rm fake*
  rm result*
}
