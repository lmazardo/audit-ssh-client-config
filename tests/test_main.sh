#!/bin/bash

source lib_test.sh

test_multiple_hosts() {
  cat << __EOF__ >"${FAKE_BAD_CONFIG}"
Host A B C
  PasswordAuthentication yes
__EOF__

  "${MAIN}" "${FAKE_BAD_CONFIG}" > "${RESULT}"

  expected_message_for_A="WARNING: PasswordAuthentication should be set to 'no' for host A"
  expected_message_for_B="WARNING: PasswordAuthentication should be set to 'no' for host B"
  expected_message_for_C="WARNING: PasswordAuthentication should be set to 'no' for host C"

  assert 'grep "$expected_message_for_A" ${RESULT}'
  assert 'grep "$expected_message_for_B" ${RESULT}'
  assert 'grep "$expected_message_for_C" ${RESULT}'
}

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
  cat << __EOF__ - "${GOOD_STAR_HOST_CONFIG}" >"${FAKE_BAD_CONFIG}"
Host hostname.com
  Username yolo
__EOF__

  "${MAIN}" "${FAKE_BAD_CONFIG}" > "${RESULT}"

  assert_equals 0 "$(wc -l "${RESULT}" | cut -d' ' -f1)"
}


teardown() {
  rm "${FAKE_BAD_CONFIG}" &> /dev/null
  rm "${FAKE_BAD_CONFIG_2}" &> /dev/null
  rm "${RESULT}"* &> /dev/null
}
