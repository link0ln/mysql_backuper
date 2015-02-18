#!/usr/bin/env perl
#===============================================================================
#
#         FILE: database_backup.pl
#
#        USAGE: ./database_backup.pl
#
#  DESCRIPTION: Backup for mysql databases
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: link0ln
# ORGANIZATION:
#      VERSION: 0.01
#      CREATED: 08.07.2014 15:39:29
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Number::Bytes::Human qw(format_bytes);

my $user        = "<user>";
my $pass        = "<password>";
my $backup_path = "/data/mysql_backups";

my @dbs = `mysql -B -u $user -p$pass -e "show databases;"`;

my $date = `date +%Y-%m-%d`;
chomp($date);

shift @dbs;

my @skip;

`mysql -B -u $user -p$pass -e "slave stop;"`;

`mkdir $backup_path/$date`;

foreach my $db (@dbs) {
  chomp($db);
  `mkdir $backup_path/$date/$db`;
  my @tables = `mysql -B -u $user -p$pass $db -e "show tables;"`;
  foreach my $table (@tables){
    chomp($table);
    if (!($db ~~ @skip)) {
        print "Starting backup $db.$table to $date/$db/$table.sql ... \n";
        `mysqldump --single-transaction -u $user -p$pass $db -t $table > $backup_path/$date/$db/$table.sql`;
        print "Archiving $table.sql to $table.sql.bz2 ... \n";
        `pbzip2 $backup_path/$date/$db/$table.sql`;
        `chmod 640 $backup_path/$date/$db/$table.sql.bz2`;
        print "Size of $table.sql.bz2 is "
          . format_bytes( -s "$backup_path/$date/$db/$table.sql.bz2" )
          . " ...\n";
    }
    else {
        print "Skipping db $db.$table \n";
    }
  }
}
`mysql -B -u $user -p$pass -e "slave start;"`;

