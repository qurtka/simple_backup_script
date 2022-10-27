#!/bin/bash

########## PARAMETERS ##########
BACKUP_DATA_DIR=/home/ubuntu/backup
BACKUP_DIR=$BACKUP_DATA_DIR/$(date +%Y%m%d_%H%M%S)
DIRECTORIES="/home/ubuntu/data/ /home/ubintu/config/"
DBUSER=root
DBPASS=#################################
DAYS_TO_STORE=30
##########/PARAMETERS ##########

echo "Started at: "$(date)
mkdir $BACKUP_DIR

#Making and archivation DB dumps
mysqldump --opt -u $DBUSER -p$DBPASS --events --all-databases > $BACKUP_DIR/all.sql
tar -cjf $BACKUP_DIR/all.sql.tbz -C $BACKUP_DIR/ all.sql
rm $BACKUP_DIR/all.sql
echo "Database backup finished"

#Making directory backups 
for DIRNAME in $DIRECTORIES
do
    echo "Backupping $DIRNAME"
    cd $DIRNAME
    FILENAME=`echo $DIRNAME | sed 's/[\/]/\_/g' | sed 's/^\_\+\|\_\+$//g'`
    tar -cjf $BACKUP_DIR/$FILENAME.tbz ./
done
echo "Directories' backupping finished"

#Changing mode
chmod -R 700 $BACKUP_DIR

#Removing old directories
cd $BACKUP_DATA_DIR
find ./* -type d -mtime +$DAYS_TO_STORE | xargs -r rm -R

echo -e "Finished at: "$date"\n"
