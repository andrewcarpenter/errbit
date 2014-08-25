#!/bin/sh

if [ $ENABLE_INSECURE_SSH_KEY ]; then
  /usr/sbin/enable_insecure_key
fi
