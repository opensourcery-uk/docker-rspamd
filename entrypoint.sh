#!/bin/bash

sed -i "s/{ CONTROLLER_PASSWORD }/${CONTROLLER_PASSWORD}/" /etc/rspamd/override.d/worker-controller.inc

if [ $? -eq 0 ]; then
  exec "$@"
fi
