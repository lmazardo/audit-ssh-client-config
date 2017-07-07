#!/bin/bash
TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

setup() {
  MAIN="$TESTS_DIR/../audit-ssh-config.sh"
  FAKE_BAD_CONFIG="$TESTS_DIR/fake_bad_config"
  FAKE_BAD_CONFIG_2="$TESTS_DIR/fake_bad_config_2"
  GOOD_STAR_HOST_CONFIG="$TESTS_DIR/fixtures/good_star_host_config"
  RAW_GOOD_STAR_HOST_CONFIG="$TESTS_DIR/fixtures/raw_good_star_host_config"
  RESULT="$TESTS_DIR/result"
}

teardown() {
  rm "${FAKE_BAD_CONFIG}" &> /dev/null
  rm "${FAKE_BAD_CONFIG_2}" &> /dev/null
  rm "${RESULT}"* &> /dev/null
}
