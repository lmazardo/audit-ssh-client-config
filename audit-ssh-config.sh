#!/bin/bash

usage() {
  [ $# -gt 0 ] && echo "$@" >&2

  echo "usage : $(basename "$0") [-h] CONFIG_FILE
audit an ssh client configuration file
--warning = filter messages to only display WARNINGs
--error = filter messages to only display ERRORs
-h = display this help" >&2
  exit 1
}

filter=""
optspec="h-:"
while getopts "$optspec" option
do
  case $option in
    -)
      case "${OPTARG}" in
        warning)
          filter="WARNING"
          ;;
        error)
          filter="ERROR"
          ;;
      esac
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

if [ $# -gt 0 ]; then
  config_file=${@: -1}
else
  usage "An ssh config file needs to be passed as a parameter."
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$DIR/config-parser.awk" "$config_file" | grep --color=never "$filter"
