# SQL Server Script to Change Recovery Mode and Perform Backup

This repository contains a SQL Server script that automates two crucial tasks in SQL Server database environments:

1. **Change Recovery Mode to "Simple"**: This script changes the recovery mode of all databases on a SQL Server instance to "Simple". The "Simple" recovery mode is suitable for databases where granular recovery to a specific point in time is not required, offering a simplified approach to transaction log management.

2. **Backup All Databases**: After changing the recovery mode, the script performs a backup of all databases to a specified directory. This ensures that, in the event of a system failure, data can be restored from the most recent backups.

### How to Use:

1. Clone this repository or download the SQL script (`backup_databases.sql`).
2. Open the script in SQL Server Management Studio (SSMS) or any similar tool.
3. Customize the destination path for backups (`@path`) as needed.
4. Execute the script on your SQL Server instance.
5. Optionally, set up automation using SQL Server Agent to run the script at regular intervals.

### Important Note:

- This script should be executed with caution in production environments, and it is recommended to test it in a development environment or on a copy of the database before using it in production. I am not liable for any damages caused by executing the script due to lack of attention.

We hope this script helps simplify and automate maintenance of your SQL Server databases!
