#!/bin/bash

# intended to run as root..
SNAPPY_BACKUP_PASSWORD=SETME

# Configuration
DATE=$(date +"%Y%m%d") # Format the date as YYYYMMDD
PARENT_DIR="/home/lathonez"
DEST_DIR="/media/lathonez/TV/snappy_backups"
ARCHIVE_NAME="snappy_backup_$DATE.tar.gz"
GIT_REPO_DIR="/home/lathonez/dotfiles"
ARCHIVE_PATH="$DEST_DIR/$ARCHIVE_NAME"

# Directories to be included in the backup
DIRECTORIES=("HomeAssistant" "nzbget" "sonarr" "radarr" "deluge")

# Create password-protected tar: password stored in Snappy HP Chromebook 14 Laptop secure noter
tar --verbose -czf - -C "$PARENT_DIR" "${DIRECTORIES[@]}" | openssl enc -aes-256-cbc -e -pbkdf2 -out "$ARCHIVE_NAME" -k "$SNAPPY_BACKUP_PASSWORD"

chown lathonez:lathonez "$ARCHIVE_NAME"

# Move the tar to the destination directory
mv "$ARCHIVE_NAME" "$ARCHIVE_PATH"
