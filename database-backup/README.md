make the file executable: 
# Run 
chmod +x db-backup.sh

## Perform a backup
./db-backup.sh -b -d your_database_name -l /path/to/backup/directory

## Perform a restore
./db-backup.sh -r -d your_database_name -l /path/to/backup/directory



Make sure to replace username with your actual database username, and adapt the script to your specific database system if it's not MySQL. Additionally, consider enhancing security by storing the database password securely and managing access control to the script.

