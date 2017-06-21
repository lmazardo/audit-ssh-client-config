#!/bin/bash

source ./test_password_authentication
source ./test_challenge_response_authentication

teardown() {
  rm fake*
  rm result*
}
