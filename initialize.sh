#!/bin/bash
set -eo pipefail

if [ -z "$USER_PASSWORD" ]; then
  echo >&2 'You need to specify USER_PASSWORD'
  exit 1
fi

if [ "$USER_NAME" ]; then
  # username specifically provided, will overwrite 'mcadmin'
  if [[ "$USER_NAME" =~ [^a-zA-Z0-9] ]]; then
    echo >&2 'USER_NAME must contain only alphanumerics [a-zA-Z0-9]'
    exit 1
  fi
else
  echo >&2 'USER_NAME not provided; defaulting to "mcadmin"'
  USER_NAME=mcadmin
fi

if id -u $USER_NAME >/dev/null 2>&1; then
  echo "$USER_NAME already exists."
else
  useradd -Ms /bin/false $USER_NAME
  echo "$USER_NAME:$USER_PASSWORD" | chpasswd
  echo >&2 "Created user: $USER_NAME"
fi

exec "$@"
