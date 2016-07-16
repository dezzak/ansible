#!/bin/bash
TODAY=`date -Idate`
LAST_WEEK=`date -Idate --date='last week'`
BACKUP_ROOT='/media/media/backups/demetria/'
RSYNC_DIR="./rsync/"
ARCHIVE_PATH="${TODAY}.tar.gz"
ENCRYPTED_ARCHIVE_PATH="${ARCHIVE_PATH}.gpg"
OLD_ARCHIVE_PATH="${LAST_WEEK}.tar.gz.gpg"
BACKUP_BUCKET="s3://backups.dezzanet.co.uk/demetria-home/"

cd $BACKUP_ROOT

# Create archive of rsync directory
/bin/tar -zcf "${ARCHIVE_PATH}" "${RSYNC_DIR}"

# Encrypt archive
/usr/bin/gpg --output "${ENCRYPTED_ARCHIVE_PATH}" --encrypt --recipient dezza@dezzanet.co.uk "${ARCHIVE_PATH}"

# Push to S3
s3cmd put "${ENCRYPTED_ARCHIVE_PATH}" "${BACKUP_BUCKET}"

# Rotate archive
s3cmd ls "${BACKUP_BUCKET}" | grep --quiet "${OLD_ARCHIVE_PATH}"
if [ ! $? ]; then
    #echo "Would remove from bucket"
    s3cmd del "${BACKUP_BUCKET}${OLD_ARCHIVE_PATH}"
else
    echo "Not found on remote"
fi

# Remove created
if [ -e "$ENCRYPTED_ARCHIVE_PATH" ]; then
    #echo "Would remove $ENCRYPTED_ARCHIVE_PATH"
    rm "$ENCRYPTED_ARCHIVE_PATH"
fi
if [ -e "$ARCHIVE_PATH" ]; then
    #echo "Would remove $ARCHIVE_PATH"
    rm "$ARCHIVE_PATH"
fi

