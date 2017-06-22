#!/bin/bash

source ./test_password_authentication
source ./test_challenge_response_authentication
source ./test_kex_algorithms

teardown() {
  rm fake*
  rm result*
}
