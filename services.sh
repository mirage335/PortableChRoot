#!/bin/bash
#Author: mirage335
#Date: 07-01-2011     (MM-DD-YYYY)
#Version: 1.0          (Minor versions reflect compatible updates.)
#Dependencies: ubiquitous_bash.sh
#Usage: services.sh start stop
#Purpose: Mounts/unmounts, enters, and starts/stops services in ChRoot.

#Loosely based on documentation available at http://wiki.debian.org/Kde4schroot .

. ubiquitous_bash.sh

mustBeRoot #Non-superuser has no ability to mount filesystems or execute chroot.

ChRootDir="$(getScriptAbsoluteFolder)/ChRoot"

case "$1" in
start)
	echo "Starting services."
	#Bind mount needed filesystems, including:
	#/dev /proc /sys /dev/pts /tmp
	mount --bind /dev "$ChRootDir"/dev
	mount --bind /proc "$ChRootDir"/proc
	mount --bind /sys "$ChRootDir"/sys
	mount --bind /dev/pts "$ChRootDir"/dev/pts
	mount --bind /tmp "$ChRootDir"/tmp

	#Provide an shm filesystem at /dev/shm.
	mount -t tmpfs -o size=4G tmpfs "$ChRootDir"/dev/shm
	
	env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(which chroot) "$ChRootDir" /bin/bash -c "/etc/init.d/mysql start"
	env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(which chroot) "$ChRootDir" /bin/bash -c "/etc/init.d/apache start"
	;;
stop)
	echo "Halting services".
	env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(which chroot) "$ChRootDir" /bin/bash -c "/etc/init.d/apache stop"
	env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(which chroot) "$ChRootDir" /bin/bash -c "/etc/init.d/mysql stop"
	
	echo "TERMinating all chrooted processes."
	sleep 5
	kill -TERM $(jailRegister "$ChRootDir"/webroot)
	kill -TERM $(jailRegister "$ChRootDir")
	
	echo "KILLing all chrooted processes."
	sleep 15
	kill -KILL $(jailRegister "$ChRootDir"/webroot)
	kill -KILL $(jailRegister "$ChRootDir")
	
	#Unmount the chroot's host-bound directories.
	umount "$ChRootDir"/proc
	umount "$ChRootDir"/sys
	umount "$ChRootDir"/dev/pts
	umount "$ChRootDir"/tmp
	umount "$ChRootDir"/dev/shm
	umount "$ChRootDir"/dev
	;;
*)
	echo "Usage: start stop ."
	;;
esac