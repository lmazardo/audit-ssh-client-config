#!/bin/bash

source ./test_password_authentication
source ./test_challenge_response_authentication
source ./test_kex_algorithms
source ./test_ciphers


test_each_message_is_displayed_only_once() {
  cat << __EOF__ >"fake_bad_config"
Host *
__EOF__

  ../main fake_bad_config > result

  # PasswordAuthentication, ChallengeResponseAuthentication,
  # KexAlgorithms, Ciphers
  # are missing and therefore trigger an error
  assert_equals 4 "$(grep -c ERROR result)"
}


teardown() {
  rm fake*
  rm result*
}
