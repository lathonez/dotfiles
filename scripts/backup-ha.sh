#!/bin/bash

# intended to run as root..

# Function to check if the variable is set
check_variable() {
  if [ -z "$1" ]; then
    echo "Error: $2 is not set. Please set it and try again."
    exit 1
  fi
}

# Configuration
DATE=$(date +"%Y%m%d") # Format the date as YYYYMMDD
SOURCE_DIR="/home/lathonez/HomeAssistant"
DEST_DIR="/media/lathonez/TV/homeassistant"
ARCHIVE_NAME="homeassistant_backup_$DATE.tar.gz"
GIT_REPO_DIR="/home/lathonez/dotfiles"
ARCHIVE_PATH="$DEST_DIR/$ARCHIVE_NAME"

# Check if the PASSWORD variable is set
check_variable "$HA_BACKUP_PASSWORD" "HA_BACKUP_PASSWORD"

# Create password-protected tar : password stored in Snappy HP Chromebook 14 Laptop secure noter
tar -czf - "$SOURCE_DIR" | openssl enc -aes-256-cbc -e -pbkdf2 -out "$ARCHIVE_NAME" -k "$HA_BACKUP_PASSWORD"
chown lathonez:lathonez $ARCHIVE_NAME

# Move the tar to the GitHub repository
mv "$ARCHIVE_NAME" "$ARCHIVE_PATH"
