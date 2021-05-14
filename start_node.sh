#!/bin/bash

exit_on_error() {
  if [ "${1}" -ne 0 ]; then
    echo "encountered error exit code: $1" 1>&2
    exit 1
  fi
}

DATA_DIR="/node/data/"

if [ -n "${NODE_DATA}" ]
then
  cp -R /node/data/* "${NODE_DATA}"
  DATA_DIR="${NODE_DATA}"
fi

./goal node start -d "${DATA_DIR}"
exit_on_error $?

sleep 10

catchpoint=$(curl https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/testnet/latest.catchpoint)
exit_on_error $?

./goal node catchup "${catchpoint}" -d "${DATA_DIR}"
exit_on_error $?

./goal node status -d "${DATA_DIR}" -w 1000
