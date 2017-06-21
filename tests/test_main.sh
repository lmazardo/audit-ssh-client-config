#!/bin/bash

#
# PasswordAuthentication
#
test_password_authentication_set_to_yes_on_a_specific_host_returns_a_warning() {
  cat << __EOF__ >"fake_bad_config"
Host hostname.com
  PasswordAuthentication yes
__EOF__

  ../main fake_bad_config > result
  expected_message="WARNING: PasswordAuthentication is set to \`yes\` for host hostname.com"

  assert "grep '$expected_message' result"
}

test_password_authentication_set_to_yes_on_star_host_returns_an_error() {
  cat << __EOF__ >"fake_bad_config"
Host *
  PasswordAuthentication yes
__EOF__

  ../main fake_bad_config > result
  expected_message="ERROR: PasswordAuthentication is set to \`yes\` for host \*"

  assert "grep '$expected_message' result"
}

test_missing_password_authentication_on_star_host_returns_an_error() {
  cat << __EOF__ >"fake_bad_config"
Host *
  Username yoloer
__EOF__

  ../main fake_bad_config > result
  expected_message="ERROR: PasswordAuthentication is missing for host \*"

  assert "grep '$expected_message' result"
}


#
# ChallengeResponseAuthentication
#
test_challenge_response_authentication_set_to_yes_on_a_specific_host_returns_a_warning() {
  cat << __EOF__ >"fake_bad_config"
Host hostname.com
  ChallengeResponseAuthentication yes
__EOF__

  ../main fake_bad_config > result
  expected_message="WARNING: ChallengeResponseAuthentication is set to \`yes\` for host hostname.com"

  assert "grep '$expected_message' result"
}

test_challenge_response_authentication_set_to_yes_on_star_host_returns_an_error() {
  cat << __EOF__ >"fake_bad_config"
Host *
  ChallengeResponseAuthentication yes
__EOF__

  ../main fake_bad_config > result
  expected_message="ERROR: ChallengeResponseAuthentication is set to \`yes\` for host \*"

  assert "grep '$expected_message' result"
}

test_missing_challenge_response_authentication_on_star_host_returns_an_error() {
  cat << __EOF__ >"fake_bad_config"
Host *
  Username yoloer
__EOF__

  ../main fake_bad_config > result
  expected_message="ERROR: ChallengeResponseAuthentication is missing for host \*"

  assert "grep '$expected_message' result"
}

teardown() {
  rm fake*
  rm result*
}
