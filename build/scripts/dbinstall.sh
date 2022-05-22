#!/bin/bash

# Enables egrep-style extended pattern matching
shopt -s extglob

# Required directories
INSTALLDIR=$HOME/lyra
SBINDIR=$INSTALLDIR/sbin
BINDIR=$INSTALLDIR/bin
DBDIR=$INSTALLDIR/db
LIBDIR=$INSTALLDIR/lib
SRCDIR=$INSTALLDIR/src
VARDIR=$INSTALLDIR/var

# Required files
HOSTIDTXT=$SRCDIR/hostid.txt
PWTXT=$SRCDIR/pw.txt

echo -n "Please enter the database hostnane:"
read -s DBHOST
echo
echo -n "Accessing DB at: $DBHOST"

echo
echo -n "Please enter the DB master username:"
read -s DBROOT
echo
echo -n "Connecting as: $DBROOT"

echo
echo -n "Please enter the database root password:"
read -s ROOTPASS

#echo
#echo "Available IP addresses: " `hostname -I`
#echo -n "Please enter the database IP address:"
#read IPADDR

# Initialize variables
IPADDR=`hostname -I`
DBPORT=3306
DBADMIN="support@underlight.com"
DBRETURNEMAIL="support@underlight.com"
DBKEY="H16 90293311ALKWEVB"
DBSALT="3A"
#DBPASS=`pwgen 15 1`
DBPASS=`tr -dc A-Za-z0-9 </dev/urandom | head -c 15 ; echo ''`
DATABASES=(ul_billing ul_guild ul_item ul_level ul_player ul_server)

echo
echo "Creating directories"
mkdir -v -p $INSTALLDIR $SBINDIR $BINDIR $DBDIR $SRCDIR $VARDIR $LIBDIR
mkdir -v -p $VARDIR/pid $VARDIR/log $VARDIR/text 


echo "1" > $HOSTIDTXT

echo "DBHOST $DBHOST" > $PWTXT
echo "DBPORT $DBPORT" >> $PWTXT
echo "DBADMIN $DBADMIN" >> $PWTXT
echo "DBRETURNEMAIL $DBRETURNEMAIL" >> $PWTXT
echo "DBKEY $DBKEY" >> $PWTXT
echo "DBSALT $DBSALT" >> $PWTXT
echo "ul_item ul_item $DBPASS" >> $PWTXT
echo "ul_player ul_player $DBPASS" >> $PWTXT
echo "ul_guild ul_guild $DBPASS" >> $PWTXT
echo "ul_level ul_level $DBPASS" >> $PWTXT
echo "ul_server ul_server $DBPASS" >> $PWTXT
echo "ul_billing ul_billing $DBPASS" >> $PWTXT

DBGRANTS='SELECT, INSERT, UPDATE, DELETE, LOCK TABLES, CREATE ROUTINE, CREATE TEMPORARY TABLES, EVENT'
echo "Installing databases"
for DATABASE in ${DATABASES[@]}
do
  echo
  echo "Processing $DATABASE"
  #mysql -h $DBHOST -u $DBROOT -p"$ROOTPASS" -e "drop database $DATABASE";
  mysql -h $DBHOST -u $DBROOT -p"$ROOTPASS" -e "create database $DATABASE";
  mysql -h $DBHOST -u $DBROOT -p"$ROOTPASS" $DATABASE < sql/$DATABASE.sql
  mysql -h $DBHOST -u $DBROOT -p"$ROOTPASS" -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO '$DATABASE'@'%' IDENTIFIED BY '$DBPASS' WITH GRANT OPTION"
  #mysql -h $DBHOST -u $DBROOT -p"$ROOTPASS" -e "GRANT $DBGRANTS ON $DATABASE.* TO '$DATABASE'@'$DBHOST' IDENTIFIED BY '$DBPASS'"
done

mysql -h $DBHOST -u $DBROOT -p"$ROOTPASS" -e "UPDATE ul_server.server SET host_name = '$IPADDR'"

echo
echo "Install complete"

