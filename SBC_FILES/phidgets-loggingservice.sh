#!/usr/bin/haserl
<? 
. /usr/lib/webif/webif.sh

load_settings network
load_settings phidgetlogging

hostname=$( hostname )

if empty "$FORM_submit"; then
	FORM_enabled="$pws_enabled"
else

	if equal "$FORM_startstop" "Start"; then
		/etc/init.d/phidgetlogging forcestart
		sleep 1
		
	elif equal "$FORM_startstop" "Stop"; then
		/etc/init.d/phidgetlogging stop
		sleep 1
	else
		validate <<EOF
EOF

		equal "$?" 0 && {
			save_setting phidgetlogging pws_enabled "$FORM_enabled"
			apply_saves
		}
	fi
fi

header "Phidgets" "Loggingservice" "Phidget Loggingservice" "$SCRIPT_NAME"



running="Stopped"
ps -Afww | grep -v grep | grep -q "phidgetlogging21" && running="Running"

if equal "$running" "Stopped"; then
	startstop="Loggingservice is <span style=\"color:red\">stopped</span>... <input type=\"submit\" value=\"Start\" name=\"startstop\" />"
else
	startstop="Loggingservice is <span style=\"color:green\">running</span>... <input type=\"submit\" value=\"Stop\" name=\"startstop\" />"
fi

display_form <<EOF
start_form|Phidget Loggingservice
field|
radio|enabled|$FORM_enabled|true|Enabled
radio|enabled|$FORM_enabled|false|Disabled
field|<br />
field|
string|$startstop
end_form
EOF

footer ?>

<!--
##WEBIF:name:Phidgets:200:Loggingservice
-->
