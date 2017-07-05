#!/bin/bash
TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

setup() {
  MAIN="$TESTS_DIR/../audit-ssh-config.sh"
  FAKE_BAD_CONFIG="$TESTS_DIR/fake_bad_config"
  RESULT="$TESTS_DIR/result"
}


source "$TESTS_DIR/ssh_parameters/test_password_authentication"
source "$TESTS_DIR/ssh_parameters/test_challenge_response_authentication"
source "$TESTS_DIR/ssh_parameters/test_host_key_algorithms"
source "$TESTS_DIR/ssh_parameters/test_kex_algorithms"
source "$TESTS_DIR/ssh_parameters/test_ciphers"
source "$TESTS_DIR/ssh_parameters/test_pubkey_authentication"
source "$TESTS_DIR/ssh_parameters/test_macs"
source "$TESTS_DIR/ssh_parameters/test_use_roaming"

source "$TESTS_DIR/test_script_usage"

source "$TESTS_DIR/test_first_parameter_value_is_the_only_one_considered"

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

test_missing_parameters_on_specific_hosts_are_not_reported() {
  cat << __EOF__ >"${FAKE_BAD_CONFIG}"
Host hostname.com
  Username yolo
__EOF__

  "${MAIN}" "${FAKE_BAD_CONFIG}" > "${RESULT}"

  assert_equals 0 "$(wc -l "${RESULT}" | cut -d' ' -f1)"
}


teardown() {
  rm "${FAKE_BAD_CONFIG}" &> /dev/null
  rm "${RESULT}"* &> /dev/null
}
