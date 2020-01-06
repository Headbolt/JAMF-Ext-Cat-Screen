#!/bin/bash
#
###############################################################################################################################################
#
#   This Script is designed for use in JAMF as an Extension Attribute
#
#   - This script will ...
#       Look at the OS Version, and if Catalina Or Higher
#		Then check the SCC Database to see if ScreenConnect
#		Is enabled for Screen Recording
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 06/01/2020
#
#   - 06/01/2020 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
osMajor=$( /usr/bin/sw_vers -productVersion | /usr/bin/awk -F. '{print $1}' )
osMinor=$( /usr/bin/sw_vers -productVersion | /usr/bin/awk -F. '{print $2}' )
osPatch=$( /usr/bin/sw_vers -productVersion | /usr/bin/awk -F. '{print $3}' )
#
###############################################################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
if [[ "$osMajor" -lt "11" ]]
	then
		if [[ "$osMajor" -lt "10" ]]
			then
				CATplus="NO"
			else 
				if [[ "$osMinor" -ge "15" ]]
					then
						CATplus="YES"
					else
						CATplus="NO"
				fi
		fi
	else
		CATplus="YES"
fi
#
if [[ "$CATplus" == "YES" ]]
	then
		SC=$(sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db 'select * from access' | grep screenconnect)
		read -ra SCstatusArray <<< "$SC"
		#
		IFS='|' # Internal Field Seperator Delimiter is set to Comma (,)
		SCstatus=$(echo $SCstatusArray | awk '{ print $4 }')
		#
		unset IFS
		#
		if [[ $SCstatus == 1 ]]
			then
				RESULT="SET"
			else
				RESULT="NOT SET"
		fi
	else
		RESULT="OS is Lower than Catalina"
fi
#
/bin/echo "<result>$RESULT</result>"
#
