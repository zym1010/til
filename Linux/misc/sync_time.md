# Sync time in Linux

March 15, 2016  
Yimeng Zhang

On Ubuntu, the automatic time sync is done via `ntpdate ntp.ubuntu.com`. According to doc of Ubuntu (<https://help.ubuntu.com/lts/serverguide/NTP.html>), this is done per reboot. However, I found that in CMU this is not done. Actually, manually running this command won't work. Instead, `ntpdate -u ntp.ubuntu.com` should be used, since by default `ntpdate` maybe uses some port that's blocked by CMU, and `-u` lets the program to use a port available.