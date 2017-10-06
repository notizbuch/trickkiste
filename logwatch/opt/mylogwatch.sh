#!/bin/sh

#Set logwatch location
LOGWATCH_SCRIPT="/usr/sbin/logwatch"
#Add options to this line. Most options should be defined in /etc/logwatch/conf/logwatch.conf,
#but some are only for the nightly cronrun such as --output mail and should be set here.
#Other options to consider might be "--format html" or "--encode base64", man logwatch for more details.
OPTIONS="--service iptables --output mail"
#OPTIONS="--service iptables"

#Call logwatch
$LOGWATCH_SCRIPT $OPTIONS

#clean iptables to prevent duplicate reporting.
> /var/log/iptables

exit 0
