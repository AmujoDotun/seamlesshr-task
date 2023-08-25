#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -b, --backup           Perform a backup"
  echo "  -r, --restore          Perform a restore"
  echo "  -d, --database         Database name"
  echo "  -l, --location         Backup file location"
  echo "  -h, --help             Display this help message"
  exit 1
}

# Function to handle backup
perform_backup() {
  local database="$1"
  local location="$2"

  echo "Performing backup of database: $database to $location"

  # Perform database dump and compress
  mysqldump -u username -p$password $database > "$location/$database.sql"
  if [ $? -eq 0 ]; then
    gzip "$location/$database.sql"
    echo "Backup completed and saved to: $location/$database.sql.gz"
  else
    echo "Error: Backup failed"
    exit 1
  fi
}

# Function to handle restore
perform_restore() {
  local database="$1"
  local location="$2"

  echo "Performing restore of database: $database from $location"

  # Decompress and restore database
  gunzip -c "$location/$database.sql.gz" | mysql -u username -p$password $database
  if [ $? -eq 0 ]; then
    echo "Restore completed"
  else
    echo "Error: Restore failed"
    exit 1
  fi
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -b|--backup)
      action="backup"
      shift
      ;;
    -r|--restore)
      action="restore"
      shift
      ;;
    -d|--database)
      database="$2"
      shift 2
      ;;
    -l|--location)
      location="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Error: Unknown option $1"
      usage
      ;;
  esac
done

# Check if required options are provided
if [ -z "$action" ] || [ -z "$database" ] || [ -z "$location" ]; then
  echo "Error: Missing required options"
  usage
fi

# Prompt for MySQL password securely
read -s -p "Enter MySQL password: " password
echo

# Perform the specified action
if [ "$action" = "backup" ]; then
  perform_backup "$database" "$location"
elif [ "$action" = "restore" ]; then
  perform_restore "$database" "$location"
else
  echo "Error: Unknown action"
  usage
fi
