#!/bin/bash
#Author: mirage335
#Date: 07-01-2011     (MM-DD-YYYY)
#Version: 1.0          (Minor versions reflect compatible updates.)
#Dependencies: ubiquitous_bash.sh
#Usage: mountChroot.sh
#Purpose: Properly mounts the associated ChRoot folder.

#Loosely based on documentation available at http://wiki.debian.org/Kde4schroot .

. ubiquitous_bash.sh

mustBeRoot #Non-superuser has no ability to mount filesystems or execute chroot.

ChRootDir="$(getScriptAbsoluteFolder)/ChRoot"

#Bind mount needed filesystems, including:
#/dev /proc /sys /dev/pts /tmp
mount --bind /dev "$ChRootDir"/dev
mount --bind /proc "$ChRootDir"/proc
mount --bind /sys "$ChRootDir"/sys
mount --bind /dev/pts "$ChRootDir"/dev/pts
mount --bind /tmp "$ChRootDir"/tmp

#Provide an shm filesystem at /dev/shm.
mount -t tmpfs -o size=4G tmpfs "$ChRootDir"/dev/shm