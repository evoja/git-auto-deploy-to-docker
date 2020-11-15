#!/bin/sh
set -e
SSH_DIR=/home/gad/.ssh
mkdir -p $SSH_DIR

if [[ -f /app/ssh-config ]]; then
    cat /app/ssh-config | grep Hostname | awk '{print $2}' | sort -u | uniq > $SSH_DIR/scanned-hosts
    ssh-keyscan -f $SSH_DIR/scanned-hosts > $SSH_DIR/known_hosts
    rm $SSH_DIR/scanned-hosts
    cat /app/ssh-config > $SSH_DIR/config
fi

if [[ -f $VOL_KEYS/known_hosts ]]; then
    cat $VOL_KEYS/known_hosts >> $SSH_DIR/known_hosts
fi

if [[ -f $VOL_KEYS/ssh-config ]]; then
    cat $VOL_KEYS/ssh-config >> $SSH_DIR/config
fi

find $SSH_DIR -type f -exec chmod 600 {} \;
chmod 700 $SSH_DIR
