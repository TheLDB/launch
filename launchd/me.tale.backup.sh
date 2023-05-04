#!/usr/bin/env zsh
LEDGER_PATH="/tmp/launchd.log"

export RESTIC_PASSWORD=$(security find-generic-password -s restic-pass -w)
export B2_ACCOUNT_ID=$(security find-generic-password -s b2-id -w)
export B2_ACCOUNT_KEY=$(security find-generic-password -s b2-key -w)

RESTIC_EXCLUDE="$DOTDIR/config/restic/excludes.txt"
DEVELOPER_PATH="$HOME/Developer"

ledger () {
	printf '[%s] (%s) %s\n' "me.tale.backup" \
		"$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> $LEDGER_PATH
	exit 1
}

if [[ ! -d $DEVELOPER_PATH ]]; then
	ledger "Developer path not found."
	exit 1
fi

if [[ ! -f $RESTIC_EXCLUDE ]]; then
	ledger "Restic exclude file not found."
	exit 1
fi

if [[ ! -f /opt/homebrew/bin/restic ]]; then
	ledger "Restic not found."
	exit 1
fi

if [[ -z $RESTIC_PASSWORD ]]; then
	ledger "Restic password not found."
	exit 1
fi

command restic -r sftp:ftp.tale.me:/tale/restic backup $DEVELOPER_PATH \
	--exclude-file $RESTIC_EXCLUDE \
	--verbose

if [[ $? -ne 0 ]]; then
	ledger "SFTP Backup failed."
	exit 1
else
	ledger "SFTP Backup succeeded."
fi

command restic -r b2:tale-ftp:/tale/restic backup $DEVELOPER_PATH \
	--exclude-file $RESTIC_EXCLUDE \
	--verbose

if [[ $? -ne 0 ]]; then
	ledger "B2 Backup failed."
	exit 1
else
	ledger "B2 Backup succeeded."
fi
