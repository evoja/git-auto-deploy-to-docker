#!/bin/sh
set -e

rm -rf $VOL_KEYS_TO/*
mkdir -p $VOL_KEYS_TO
cp -R $VOL_KEYS_FROM/* $VOL_KEYS_TO

if [[ -f $VOL_KEYS_TO/ssh-config ]]; then
  cat $VOL_KEYS_TO/ssh-config | grep Hostname | awk '{print $2}' | sort -u | uniq > $VOL_KEYS_TO/scanned-hosts
  ssh-keyscan -f $VOL_KEYS_TO/scanned-hosts >> $VOL_KEYS_TO/known_hosts
  rm $VOL_KEYS_TO/scanned-hosts
  cat $VOL_KEYS_TO/known_hosts
fi

rm -rf $VOL_SECRETS_TO/*
mkdir -p $VOL_SECRETS_TO
cp -R $VOL_SECRETS_FROM/* $VOL_SECRETS_TO

find $VOL_KEYS_TO -type f -exec chmod 400 {} \;
chmod 500 $VOL_KEYS_TO
find $VOL_SECRETS_TO -type f -exec chmod 400 {} \;
chmod 500 $VOL_SECRETS_TO

chown -R $GAD_UID:$GAD_GID $VOL_SECRETS_TO $VOL_KEYS_TO
