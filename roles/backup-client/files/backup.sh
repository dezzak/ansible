#!/bin/bash
# Backup script

REMOTE_RSYNC_PATH='henrietta.internal.dezzanet.co.uk:/media/media/backups/demetria/rsync'
LOCAL_RSYNC_PATH='/home/dezza/'

# Make sure that we're not already running
if ! mkdir /tmp/backupscript.lock 2>/dev/null; then
    echo "Backup Script is already running." >&2
    exit 1
fi
trap "rm -rf /tmp/backupscript.lock; exit" INT TERM EXIT

rsync -az --delete $LOCAL_RSYNC_PATH -e ssh $REMOTE_RSYNC_PATH -F


rm -rf /tmp/backupscript.lock
