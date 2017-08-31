# File System

## Table of content
- [Common](#common)
- [File System](#file-system)


## Common
1. ["On a UNIX system, everything is a file; if something is not a file, it is a process."](http://www.tldp.org/LDP/intro-linux/html/sect_03_01.html)
1. File extension does not play any role.

## File system
1. To get help about linux file system use
    ```
    man hier
    ```
1. [File system description [rus]](https://stepik.org/lesson/28949/step/2?course=%D0%9E%D1%81%D0%BD%D0%BE%D0%B2%D1%8B-Linux&unit=9961)

1. Subdirectories of the `/` directory

| Directory	| Content |
| --------- | ------- |
| /bin |	Common programs, shared by the system, the system administrator and the users. |
| /boot |	The startup files and the kernel, vmlinuz. In some recent distributions also grub data. Grub is the GRand Unified Boot loader and is an attempt to get rid of the many  |different boot-loaders we know today.
| /dev |	Contains references to all the CPU peripheral hardware, which are represented as files with special properties. |
| /etc |	Most important system configuration files are in /etc, this directory contains data similar to those in the Control Panel in Windows |
| /home |	Home directories of the common users. |
| /initrd |	(on some distributions) Information for booting. Do not remove! |
| /lib |	Library files, includes files for all kinds of programs needed by the system and the users. |
| /lost |+found	Every partition has a lost+found in its upper directory. Files that were saved during failures are here. |
| /misc |	For miscellaneous purposes. |
| /mnt |	Standard mount point for external file systems, e.g. a CD-ROM or a digital camera. |
| /net |	Standard mount point for entire remote file systems |
| /opt |	Typically contains extra and third party software. |
| /proc |	A virtual file system containing information about system resources. More information about the meaning of the files in proc is obtained by entering the command man  |proc in a terminal window. The file proc.txt discusses the virtual file system in detail.
| /root |	The administrative user's home directory. Mind the difference between /, the root directory and | /root |, the home directory of the root user. |
| /sbin |	Programs for use by the system and the system administrator. |
| /tmp |	Temporary space for use by the system, cleaned upon reboot, so don't use this for saving any work! |
| /usr |	Programs, libraries, documentation etc. for all user-related programs. |
| /var |	Storage for all variable files and temporary files created by users, such as log files, the mail queue, the print spooler area, space for temporary storage of files  |downloaded from the Internet, or to keep an image of a CD before burning it.
