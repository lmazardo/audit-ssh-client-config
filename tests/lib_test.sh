#!/bin/bash
TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MAIN="$TESTS_DIR/../audit-ssh-config.sh"

GOOD_STAR_HOST_CONFIG="$TESTS_DIR/fixtures/good_star_host_config"
RAW_GOOD_STAR_HOST_CONFIG="$TESTS_DIR/fixtures/raw_good_star_host_config"

FAKE_BAD_CONFIG=$(mktemp)
FAKE_BAD_CONFIG_2=$(mktemp)

RESULT=$(mktemp)


teardown() {
  rm "${FAKE_BAD_CONFIG}" &> /dev/null
  rm "${FAKE_BAD_CONFIG_2}" &> /dev/null
  rm "${RESULT}"* &> /dev/null
}
