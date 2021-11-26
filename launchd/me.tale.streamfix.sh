#!/bin/bash
if test $(pgrep -x -- parsecd | wc -l) -eq 2; then
	# When Parsec runs 2 instances of the Daemon, we are in remote play
	# Many people suggested disabling Location Services & AirDrop to stop stuttering
	# This network interface controls that ability so we disable it
	if ifconfig awdl0 | grep "status: active" > /dev/null; then
		ifconfig awdl0 down
		printf '[%s] (%s) %s\n' "me.tale.streamfix" "$(date '+%H:%M:%S')" "'awdl0' disabled after Parsec startup"
	fi

else
	if ifconfig awdl0 | grep "status: inactive" > /dev/null; then
		ifconfig awdl0 up
		printf '[%s] (%s) %s\n' "me.tale.streamfix" "$(date '+%H:%M:%S')" "'awdl0' enabled after Parsec shutdown"
	fi
fi
