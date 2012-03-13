#!/bin/bash
#Author: mirage335
#Date: 07-01-2011     (MM-DD-YYYY)
#Version: 1.0          (Minor versions reflect compatible updates.)
#Dependencies: ubiquitous_bash.sh
#Usage: enterChroot.sh
#Purpose: Dismounts bound filesystems in the ChRoot folder.

. ubiquitous_bash.sh

mustBeRoot #Non-superuser has no ability to mount filesystems or execute chroot.

ChRootDir="$(getScriptAbsoluteFolder)/ChRoot"

umount "$ChRootDir"/proc
umount "$ChRootDir"/sys
umount "$ChRootDir"/dev/pts
umount "$ChRootDir"/tmp
umount "$ChRootDir"/dev/shm
umount "$ChRootDir"/dev