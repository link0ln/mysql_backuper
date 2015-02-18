# mysql_backuper

This script will backup all mysql db to different dirs by name of DBs.
Dirs will contain compressed tables data like <name>.tar.bzip2 for each table.

###First of all change in script:
```perl
my $user        = "<user>"; # username to connect to localhost
my $pass        = "<password>"; #password to connect to localhost
my $backup_path = "/data/mysql_backups"; # path without last slash
```
