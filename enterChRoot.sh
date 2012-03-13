#!/bin/bash
#Author: mirage335
#Date: 07-01-2011     (MM-DD-YYYY)
#Version: 1.0          (Minor versions reflect compatible updates.)
#Dependencies: ubiquitous_bash.sh
#Usage: enterChroot.sh
#Purpose: Enters the associated ChRoot folder.

. ubiquitous_bash.sh

mustBeRoot #Non-superuser has no ability to mount filesystems or execute chroot.

ChRootDir="$(getScriptAbsoluteFolder)/ChRoot"/

env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(which chroot) "$ChRootDir" /bin/bash