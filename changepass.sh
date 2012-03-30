#!/bin/bash

# --- Change domain password ver 0.1

# --- Looks for the existance of smbpasswd, if it doesnt't exist (aka OS X Lion)
# --- it will connect to a linux host and run the command from there.
# --- The credentials for the linux box will be hardcoded into this script and
# --- the linux host in question should have a restricted shell for security sake.

# Command usage
USAGE="Usage: `basename $0` username\nExample: `basename $0` jdoe\n\nMake sure your VPN is connected"

# Make sure the user provided a username
if [[ $# -eq 0 ]]; then
	echo -e $USAGE >&2
	exit 1
fi


# look for passwd locally and decide if we can continue here
PASSWDPATH=`whereis smbpasswd`
if [[ -z "PASSWDPATH" ]]; then
	echo "smbpasswd found in system, continuing locally -- $PASSWDPATH --"
	smbpasswd -U $1 -r 192.168.25.21
else
	echo "smbpasswd not found, establishing connection with a remote system, $1."
	ssh -l aisight 192.168.25.111 smbpasswd -U $1 -r 192.168.25.21
fi