#!/bin/bash
TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

setup() {
  MAIN="$TESTS_DIR/../main"
  FAKE_BAD_CONFIG="$TESTS_DIR/fake_bad_config"
  RESULT="$TESTS_DIR/result"
}


source "$TESTS_DIR/test_password_authentication"
source "$TESTS_DIR/test_challenge_response_authentication"
source "$TESTS_DIR/test_host_key_algorithms"
source "$TESTS_DIR/test_kex_algorithms"
source "$TESTS_DIR/test_ciphers"
source "$TESTS_DIR/test_pubkey_authentication"
source "$TESTS_DIR/test_macs"
source "$TESTS_DIR/test_use_roaming"


test_each_message_is_displayed_only_once() {
  cat << __EOF__ >"${FAKE_BAD_CONFIG}"
Host *
__EOF__

  "${MAIN}" "${FAKE_BAD_CONFIG}" > "${RESULT}"

  # PasswordAuthentication, ChallengeResponseAuthentication, HostKeyAlgorithms
  # KexAlgorithms, Ciphers, PubkeyAuthentication, MACs, UseRoaming
  # are missing and therefore trigger an error
  assert_equals 8 "$(grep -c ERROR "${RESULT}")"
}


teardown() {
  rm "${FAKE_BAD_CONFIG}"
  rm "${RESULT}"
}
