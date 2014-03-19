########################################################################
# Start/Stop Script for Domino on xLinux/zLinux/AIX/Solaris
# 2005-2013 Copyright by Daniel Nashed, feedback domino_unix@nashcom.de
# You may use and distribute the unmodified version of this script.
# Use at your own risk. No implied or specific warranties are given.
# You may change it for your own usage only
# Version 2.7 01.09.2013
########################################################################

Note: See end of file for detailed Change History

------------
Introduction
------------

The Domino cross platform start/stop and diagnostic script has been written
to unify and simplify running Domino on Linux and Unix. The start script
is designed to be "one-stop shopping" for all kind of operations done on the
Unix prompt. The script can start and stop the server, provides an interactive
console and run NSD in different flavors.
It ensures that the environment is always setup correct and supports multiple partitions.

But is not intended to set all the OS-level tuning. 
Tuning your OS-level environment should be always done on OS-level directly
(See section Tuning your OS-level Environment for Domino for details).

Tuning your OS-level environment in the start script would imply having root 
permissions to start the Domino server. 
This script is designed to run with the standard "notes" user for each partition.

Note: For RHEL you need to have root permissions to start/stop the server.

-------------------
Quick Configuration
-------------------

1.) Copy Script Files 

a.) Copy the script rc_domino_script into your Domino binary directory (e.g. /opt/ibm/lotus)
b.) Copy rc_domino into /etc/init.d 
c.) Ensure the variable DOMINO_START_SCRIPT (default is /opt/ibm/lotus/rc_domino_script) 
    matches the location of your main start script.

2.) Ensure the script files are executable by the notes user

    Example: 
    cd /opt/ibm/lotus
    chmod 755 rc_domino_script
    cd /etc/init.d
    chmod 755 rc_domino

3.) Check Configuration 

Ensure that your Unix user name matches the one in the configuration part 
of the Domino server. Default is "notes"

4.) Ensure to setup at least the following script variables per Domino partition.

- LOTUS 
  Domino binary directory 
  default: /opt/ibm/lotus

- DOMINO_DATA_PATH
  Domino data directory
  default: /local/notesdata

  This can be done either in the rc_domino_script or in a configuration script 
  per Domino partition. The new default location is in 
  /etc/sysconfig/rc_domino_config_$DOMINO_USER
  A sample configuration file comes with the script
  But for a single partition the defaults in the start script might work.
  For AIX and Solaris you may have to create this directory.

5.) Special platform considerations

    AIX/Solaris
    -----------
    For AIX and Solaris change first line of the scripts from "#!/bin/sh" to "#!/bin/ksh"    
    Domino on Linux use "sh". AIX and Solaris uses "ksh". 
    The implementation of the shells differs in some ways on different platforms. 
    Make sure you change this line in rc_domino and rc_domino_script


    On AIX you can use the mkitab to include rc_domino in the right run-level
    Example: mkitab domino:2:once:"/etc/rc_domino start"


    SLES
    ----
    The script (rc_domino) contains the name of the service. If you modify the name of 
    the script you need to change the "Provides:"-line in the main rc-script
    Example: " # Provides: rc_domino"

    On SLES you can use the insserv command or run-level editor in YaST
    Example: insserv /etc/init.d/rc_domino

    To verify that your service is correctly added to the rc-levels use the following command
    
    find /etc/init.d/ -name "*domino*"

    Sample Output:
     /etc/init.d/rc3.d/K13rc_domino
     /etc/init.d/rc3.d/S09rc_domino
     /etc/init.d/rc5.d/K13rc_domino
     /etc/init.d/rc5.d/S09rc_domino
     /etc/init.d/rc_domino

    RedHat/CentOS
    -------------
    On RedHat/CentOS you can use the chkconfig to add Domino to the run-level environment
    
    Example: chkconfig --add rc_domino 

    To verify that your service is correctly added to the rc-levels use the following command

    find /etc/ -name '*domino*' 
    etc/sysconfig/rc_domino_config_notes 
    /etc/rc.d/rc0.d/K19rc_domino 
    /etc/rc.d/init.d/rc_domino 
    /etc/rc.d/rc2.d/K19rc_domino 
    /etc/rc.d/rc6.d/K19rc_domino 
    /etc/rc.d/rc4.d/S66rc_domino 
    /etc/rc.d/rc3.d/S66rc_domino 
    /etc/rc.d/rc1.d/K19rc_domino 
    /etc/rc.d/rc5.d/S66rc_domino 

    And you can also query the runlevels like this 

    chkconfig --list | grep -i domino 
    rc_domino       0:off   1:off   2:off   3:on    4:on    5:on    6:off 


-------------------------
Components of the Script
-------------------------

1.) rc_domino

  This shell script has two main purposes

  - Have a basic entry point per instance to include it in "rc" run-level 
    scripts for automatic startup of the Domino partition 
    You need one script per Domino partition or a symbolic link
    with a unique name per Domino partition.

  - Switch to the right user and call the rc_domino_script.
  
  Notes:
   
  - If the user does not change or you invoke it as root you will not
    be prompted for a password. Else the shell prompts for the Notes 
    Unix user password.
   
  - The script contains the location of the rc_domino_script. 
    You have to specify the location in DOMINO_START_SCRIPT
    (default is /opt/ibm/lotus/rc_domino_script).
      

2.) rc_domino_script 

  This shell script contains
 
  - Implementation of the shell logic and helper functions.
  
  - General configuration of the script.

  - The configuration per Domino server specified by notes Linux/Unix user.
    You have to add more configurations depending on your Domino partition setup.
    
    This is now optional and we recommend using the rc_domino_config_xxx files
    
3.) rc_domino_config_xxx

  This file is located by default in /etc/sysconfig and can be used as an external
  configuration (outside the script itself).
   
  Note: On AIX and Solaris this directory is not standard but you can create it 
  or if really needed change the location the script.
  
  There is one configuration file per Domino partition and the last part of the name 
  determins the partition it is used for. 
  
  Examples:
    rc_domino_config_notes, rc_domino_config_notes1, rc_domino_config_notes2, ...
  
  If this file exists for a partition those parameters are used for server 
  start script configuration.
  
  This way you can completely separate configuration and script logic.
  You could give even write permissions to Domino admins to allow them to change
  the start-up script configuration. 
  
  This file only needs to be readable in contrast to rc_domino and rc_domino_script 
  which need to be executable. 

---------------------
Commands & Parameters
---------------------

start
-----

Starts the Domino server and archives the last OS-level Domino output-file.
The output-file is renamed with a time-stamp and compressed using the 
configured compression tool. Compressing the log file is invoked in background
to avoid slowing down the server start when compressing large log-files.
The start operation does clear the console input file and logs information
about the Unix user environment and the security limits of the Unix user.

start live
----------
Same as "start" but displays the live console at restart.
See "monitor" command for details

stop
----

Stops the Domino server via server -q and waits a given grace period 
(configurable via DOMINO_SHUTDOWN_TIMEOUT -- default 10 minutes).
After this time the Domino server is killed via NSD if it cannot be shutdown
and processes are still ruining after this time (see "kill" command below)
The Java controller remains active if configured.
If you specify "stop live" the live console is shown during shutdown.

stop live
---------
Same as "stop" but displays the live console during shutdown.
The live console is automatically closed after shutdown of the server
See "monitor" command for details

stopjc
------

In case you configured to use the Java controller (USE_JAVA_CONTROLLER) this
command shuts down the controller component.
When starting the server and the controller is running it will be shutdown 
before starting the server. There is currently no way to restart Domino with
a running Java Controller from the Domino console.
The work-around is to stop and restart the controller.

restart
-------

Stops the Domino server and restarts it using "stop" and "start" command with
all implications and specially the time-out values for "stop".

restart live
------------
Same as "restart" but displays the live console for server/start stop
See "monitor" command for details


status
------

Checks if the Domino server is running and prints a message.

Return code of the script:
 0 = server is not running
 3 = server is running

monitor
-------

Attaches to the output and the input files of a running Domino server and 
allows a kind of live console from a telnet/ssh session using the input
and output files. ctrl+c or "stop" terminates the live console.

cmd
---
Issue console commands from the linux command line
Syntax: rc_domino_script cmd "command" [n log lines]
The command needs to be specified in double-quotes like shown above.
The optional parameter log lines can be used to print the last n lines of 
log file (via tail) after waiting 5 seconds for the command to finish

Example: rc_domino_script cmd "show server" 200
issues a remote console command, waits 5 seconds and displays the last 200 lines

archivelog
----------

Archives the current server text log-file. The file is copied, compressed and 
the current log file is set to an empty file without losing the current 
file-handles of the server process. There might be a very short log file 
interruption between copying the file and setting it to an empty file. 
The new log file contains a log-line showing the archived log file name.

info
----

Generates a sysinfo style NSD (nsd -info). 

nsd
---

Generates a NSD without memcheck (nsd -nomemcheck).

fullnsd
-------

Generates a full NSD including call-stacks and memcheck

kill
----

Terminates the Domino server (nsd -kill)

cleanup
-------

Remove hanging resources after a server crash
(processes, shared memory, semaphores, message queues)

In contrast to the NSD -kill option this routine removes ALL resources.
This includes all message queues, shared memory, semaphores allocated by 
the UNIX user used by the Domino server instance.
And also removes all processes started from the server binary directory
(e.g. /opt/ibm/lotus).
NSD currently does only remove registered resources in the following files:
pid.nbf, mq.nbf, sem.nbf, shm.nbf

So this command is mainly useful if NSD cannot remove all resources due to 
corruptions or add-on programs or any other odd situation.
It prevents you from having to manually remove resources and processes in
such a corrupt state. 

Note: Resources allocated by add-on applications using native OS-level 
operations are not registered.
  
memdump
-------
Generate a memory dump from the currently running server. 

hang
----
generate 3 NSDs collecting the call-stacks and one additional full NSD
this option is needed collecting troubleshooting data for server hang analysis



compact
-------
runs compact when server is shutdown (if the server is started an error message is displayed, you have to shutdown the server first)
needs DOMINO_COMPACT_OPTIONS to be configured and is mainly intended for system databases

restartcompact
--------------

terminates the server, runs compact and restarts the server.
needs DOMINO_COMPACT_OPTIONS to be configured and is mainly intended for system databases


Configuration Parameters
------------------------

Variables can be set in the rc_domino_script per user (configuration settings) 
or in the profile of the user. 
Once the configuration is specified you need to set DOMINO_CONFIGURED="yes"


DOMINO_USER
-----------
(Required)
User-variable automatically set to the OS level user (indirect configuration)


LOTUS
-----
(Required)
Domino installation directory (usual /opt/lotus or /opt/ibm/lotus in D7)
This is the main variable which needs to be set for binaries 
Default: /opt/ibm/lotus 


DOMINO_DATA_PATH
----------------
(Required)
Data-Directory
Default: /local/notesdata


DOMINO_LANG
-----------
(Required)
Language setting used to determine local settings 
(e.g. decimal point and comma)
Examples: DOMINO_LANG=en_US.UTF-8
Default: not set --> uses the setting of the Unix/Linux user


DOMINO_CONFIGURED
-----------------
(Required)
Configuration variable. Needs to be set to "yes" per user to confirm
that the environment for this user is setup correctly


DOMINO_SHUTDOWN_TIMEOUT
-----------------------
(Optional)
Grace period in seconds (default: 600) to allow to wait until the Domino 
server should shutdown. After this time nsd -kill is used to terminate
the server. 


DOMINO_OUTPUT_LOG
-----------------
(Optional)
Output log file used to log Domino output into a OS-level log file 
(used for troubleshooting and the "monitor" option).
Default: "username".log in data-directory


DOMINO_INPUT_FILE
-----------------
(Optional)
Input file for controlling the Domino server (used for "monitor" option)
Default: "username".input in data-directory


DOMINO_LOG_DIR
--------------
(Optional)
Output log file directory for domino log files. This is only used if you don't specify DOMINO_INPUT_FILE.
Default: DOMINO_DATA_PATH


DOMINO_LOG_BACKUP_DIR
---------------------
(Optional)
Output log file backup directory for domino log files for achiving log files.
Default: DOMINO_DATA_PATH


USE_JAVA_CONTROLLER
-------------------

(Optional - Not Recommended)
Use the Java Controller to manage the Domino server. 
Specify "yes" to enable this option.

We do not recommend using the Java Controller. The file redirection in 
combination with the "monitor" option is a way easier and more standard
way, that provides better resource usage
(does not need an extra environment around the server). 


COMPRESS_COMMAND
----------------

(Optional)
Command that is used to compress log files. There might be different options 
possible depending on your platform and your installed software
e.g. compress, zip, gzip, ...
(default: "gzip --best").


DOMINO_DEBUG_MODE
-----------------

(Optional)
Enabling the debug mode via DOMINO_DEBUG_MODE="yes" allows to trace and 
troubelshoot the start script. Enable this option only for testing!

DOMINO_DEBUG_FILE
---------------------------
(Optional)
When you enable the debug mode debug output is written to the console
This option allows to specify a separate debug output file.
Note: Works in combination with DOMINO_DEBUG_MODE="yes"


DOMINO_RESET_LOADMON
--------------------

(Optional - Recommended - Default)
Domino calculates the Server Availability Index (SAI) via LoadMon by calculating 
the current transaction times and the minimum trasnactions times which are 
stored in loadmon.ncf when the server is shutdown.
This file can only be deleted when the server is showdown.
Enable this option (DOMINO_RESET_LOADMON="yes") to remove loadmon.ncf at server startup
Note: When using this option you will only see a loadmon.ncf in the data directory,
when the server is down, because it will be only written at server shutdown time.


DOMINO_NSD_BEFORE_KILL
----------------------

(Optional - Recommended - Default)
Generates a NSD before finally using NSD -kill to recycle the server.
This is specially interesting to troubleshoot server shutdown issues.
Therefore the option is enabled by default in current configuration files.
Enable this option via (DOMINO_NSD_BEFORE_KILL="yes")

DOMINO_REMOVE_TEMPFILES
-----------------------

(Optional)
Enable this option (DOMINO_REMOVE_TEMPFILES="yes") to remove temp-files from 
data-directory at server startup. The following files are removed:
*.DTF, *.TMP

!Caution!
---------
Take care that some TMP files can contain important information.
For example files generated by SMTPSaveImportErrors=n
In such cases you have to move those files before restarting the server
Server-Restart via Fault-Recovery is not effected because the internal start
routines do generally not call this start script



NSD_SET_POSIX_LC
---------------------------
Set the locale to POSIX (C) when running NSD


DOMINO_PRE_SHUTDOWN_COMMAND
---------------------------

Command to execute before shutting down the Domino server.
In some cases, shutting down a certain servertask before shutting down the 
server reduces the time the server needs to shutdown.


DOMINO_PRE_SHUTDOWN_DELAY
-------------------------

Delay before shutting down the Domino server after invoking the pre-shutdown 
command. If configured the shutdown waits this time until invoking the 
actual shutdown after invoking the DOMINO_PRE_SHUTDOWN_COMMAND command.


DOMINO_VIEW_REBUILD_DIR
-----------------------

View Rebuild Directory which will be created if not present.
This option is specially useful for servers using temp file-systems with 
subdirectories for example for each partitioned servers separately.
Use notes.ini view_rebuild_dir to specify directory

DOMINO_TEMP_DIR
---------------

Notes Temporary Directory which will be created if not present.
This option is specially useful for servers using temp file-systems with 
subdirectories for example for each partitioned servers separately.
Use notes.ini notes_tempdir to specify directory

DOMINO_LOG_PATH
---------------

Log Directory which will be created if not present.
This option is specially useful for servers using temp file-systems with 
subdirectories for example for each partitioned servers separately.
Use notes.ini logfile_dir to specify directory

The following settings are intended to add functionality to the existing start script without modifying the code directly.
Those scripts inherit all current variables of the main script. 
The scripts are invoked as kind of call-back functionality.
You have to ensure that those scripts terminate in time.


DOMINO_3RD_PARTY_BIN_DIRS
-------------------------
3rd Party directories to check for running processes when cleaning up server resources
specify separte directories with blank inbetween. directory names should not contain blanks.
those directories are also checked for running processes when cleaning up server resources via "clenup" command
by default only the $LOTUS directory is checked for running binaries



DOMINO_PRE_STARTUP_SCRIPT
--------------------------

this script is invoked before starting the server

DOMINO_POST_STARTUP_SCRIPT
--------------------------

this script is invoked after starting the server


DOMINO_PRE_SHUTDOWN_SCRIPT
--------------------------

this script is invoked before shutting down the server

DOMINO_POST_SHUTDOWN_SCRIPT
---------------------------

this script is invoked after shutting down the server


DOMINO_PRE_KILL_SCRIPT 
----------------------

this script is invoked before any "nsd -kill" is executed


DOMINO_POST_KILL_SCRIPT
-----------------------

this script is invoked after any "nsd -kill" is executed


DOMINO_PRE_CLEANUP_SCRIPT
-------------------------

this script is invoked before cleaning up server resources native on OS level


DOMINO_POST_CLEANUP_SCRIPT
--------------------------

this script is invoked after cleaning up server resources native on OS level


DOMINO_START_COMPACT_OPTIONS
----------------------------

specifies which compact should be executed before Domino server start
this allows regularly compact of e.g. system databases when the server starts
you should specify an .ind file for selecting system databases
an example which is disabled by default is included in the config file

DOMINO_COMPACT_OPTIONS
----------------------

specifies which compact options to use when using the "compact" and "restartcompact" commands
you should specify an .ind file for selecting system databases
an example which is disabled by default is included in the config file

Additional Options
------------------------
You can disable starting the Domino server temporary by creating a file in the 
data-directory named "domino_disabled". If the file exists when the start 
script is called, the Domino server is not started

-----------------------------
Differences between Platforms
-----------------------------

The two scripts use the Korn-Shell (/bin/ksh) on Solaris and AIX.
On Linux the script needs uses /bin/sh.
Edit the first line of the script according to your platform
Linux: "#!/bin/sh"
AIX and Solaris: "#!/bin/ksh" 


-------------------------------------------
Tuning your OS-level Environment for Domino
-------------------------------------------

Tuning your OS-platform is pretty much depending the flavor and version of 
Unix/Linux you are running. You have to tune the security settings for 
your Domino Unix user, change system kernel parameters and other system 
parameters.

The start script queries the environment of the Unix notes user and 
the basic information like ulimit output when the server is started.

The script only sets up the tuning parameters specified in the Unix user 
environment. There is a section per platform to specify OS environment 
tuning parameters.

Linux
-----

export NOTES_SHARED_DPOOLSIZE=20971520
Specifies a larger Shared DPOOL size to ensure proper memory utilization.

Detailed tuning is not part of this documentation.
If you need platform specify tuning feel free to contact
domino_unix@nashcom.de


----------------------
Implementation Details
----------------------

The main reason for having two scripts is the need to switch to a different 
user. Only outside the script the user can be changed using the 'su' command
and starting another script. On some platforms like Linux you have to ensure
that su does change the limits of the current user by adding the pam limits
module in the su configuration. 

In the first implementation of the script the configuration per user was 
specified in the first part of the script and passed by parameter to the 
main script. This approach was quite limited because every additional parameter
needed to be specified separately at the right position in the argument list.
Inheriting the environment variables was not possible because the su command
does discard all variables when specifying the "-" option which is needed
to setup the environment for the new user.
Therefore the beginning of the main script contains configuration parameters
for each Domino partitions specified by Unix user name for each partition.


------------
Known Issues
------------


Domino on Solaris SIGHUB Issue
------------------------------

Domino on Solaris has a known limitations when handling the SIGHUB signal.
Normally the Domino Server does ignore this signal. But the currently used
JVM crashes when receiving the signal. Starting the server via nohub does 
not solve the issue. The only two known working configurations are:

a.) Invoke the bash before starting the server

b.) - Ensure that your login shell is /bin/ksh
    - Start server always with "su - " (switch user) even if you are already
      running with the right user. The su command will start the server in 
      it's own process tree and the SIGHUB signal is not send to the Domino
      processes. 
      
      Note: The start-script does always switch to the Domino server user 
      for the "start" and "restart" commands.
      For other commands no "su -" is needed to enforce the environment.
      Switching the user from a non-system account (e.g. root) will always 
      prompt for password -- even when switching to the same Unix user.
      +
SELinux (RedHat) RC-start level issue
-------------------------------------

Depending on your configuration the RC-subsystem will ask for confirmation 
when starting Domino when switching the run-level.

To avoid this question you have to ensure that your pam configuration for 
"su" is setup correctly. 

remove the "multiple" from the pam_selinux.so open statement

example: /etc/pam.d/su
session    required     pam_selinux.so open multiple

extract from pam_selinux documentation

multiple 

Tells pam_selinux.so to allow the user to select the security context they 
will login with, if the user has more than one role.

This ensures that there are no questions asked when starting the Domino server 
during run-level change.

!Caution!
---------
Modifying the script to use "runuser" instead of "su" is not a solution,
because "runuser" does not enforce the /etc/security/limits specified for the 
notes-user. 
This means that the security limits (max. number of open files, etc.)might be to low. 
You can check for the security limits in the output log of the script. 
The ulimit output is dumped when the server starts.

!Note!
------
To enforce the security limits for the user you have to add the following line
to /etc/security/limits before pam_selinux.so open

session    required     pam_limits.so

SLES10 does contain this setting by default.
The default settings have been enhanced and different parts use include files.
The include file used for "session" settings contains this entry already.


--------------
Change History
--------------

V2.7 01.09.2013

New Features
------------

New Option DOMINO_3RD_PARTY_BIN_DIRS to allow "cleanup" to kill processes started from 3rd Party directories

Changes
-------
When you try to shutdown a Domino server the script checks now if the server is started at all before inititiating the shutdown.
In previous versions this took a longer time because the loop for termination check was invoked anyway.
Also pre-shutdown scripts have been invoked which lead to a delay.
The script also skips post_shudown operations in this case.
You will see a message on the console that shutdown is skipped because the server is not started.
This will improve shutdown performance when the server was not started.


V2.6 03.01.2013

New Features
------------

New Option DOMINO_PRE_KILL_SCRIPT to allow invoking a script before "nsd -kill"
New Option DOMINO_POST_KILL_SCRIPT to allow invoking a script after "nsd -kill"

New Option DOMINO_PRE_CLEANUP_SCRIPT to allow invoking a script before cleaning up server resources native on OS level
New Option DOMINO_POST_CLEANUP_SCRIPT to allow invoking a script after cleaning up server resources native on OS level

Added Debug Output (BEGIN/END) for all pre/post scripts

V2.5 14.08.2012

New Features
------------

New Option DOMINO_TEMP_DIR to allow creation of the Notes Temp dir if not present

New DOMINO_START_COMPACT_OPTIONS to allow compact before Domino server start
New DOMINO_COMPACT_OPTIONS to control compact options when using the "compact" and "restartcompact" commands

New command "compact" to compact when server is not started
New command "restartcompact" to terminate, compact and start the server

The compact options are mainly designed to compact system databases


V2.4 10.04.2012

Problems Solved
---------------
Solved an issue when closing a terminal window while the monitor was running.
With some OS releases and some shells this caused that the script did not terminate due to issues in the shell.
This could lead to high CPU usage (100% for one core) for the script because the loop did not terminate.
The change to catch more events from the shell should resolve this issue.
If you still run into problems in this area, please send feedback.

V2.3 04.01.2012

New Features
------------

New Option DOMINO_TEMP_DIR to allow creation of the Notes Temp dir if not present
New Option DOMINO_LOG_DIR to allow creation of the Notes Log dir if not present
New Option DOMINO_DEBUG_FILE to allow use a debug file for start script debug output

V2.2 01.03.2011 

New Features
------------

New Option DOMINO_VIEW_REBUILD_DIR to allow creation of the view rebuild dir if not present

New Option DOMINO_PRE_SHUTDOWN_SCRIPT to allow invoking a script before shutting down the server
New Option DOMINO_POST_SHUTDOWN_SCRIPT to allow invoking a script after shutting down the server

New Option DOMINO_PRE_STARTUP_SCRIPT to allow invoking a script before starting the server
New Option DOMINO_POST_STARTUP_SCRIPT to allow invoking a script after starting the server 


DOMINO_PRE_STARTUP_SCRIPT
--------------------------

this script is invoked before starting the server

DOMINO_POST_STARTUP_SCRIPT

Changes
-------

- Changed the default for the DOMINO_LANG variable. By default the variable was set to DE_de. 
  For current Linux versions the LANG variable is set to the UTF-8 setting instead of the older setting.
  There are some odd issues on Traveler servers when you use the older settings.
  Therefore the new default setting is to use the default settings for the user.
  The configuration file holds the UTF-8 version for German and English in comment strings to make it easier to enable them if needed.
  Example: #DOMINO_LANG=en_US.UTF-8


V2.1 01.11.2010

New Features
------------

New option to allow a pre-shutdown command before shutting down the server.
The command is configured via DOMINO_PRE_SHUTDOWN_COMMAND.
And there is also an optional delays time DOMINO_PRE_SHUTDOWN_DELAY.


V2.0 01.09.2010

Changes
-------

Changed the behaviour of the "hang" function which now does now only dump call-stacks in the first 3 NSDs instead of NSD just without memcheck.
This can be a bit faster specially on larger servers. 

Problems Solved
---------------

Fixed and issue on Solaris with the tail command.
Some options of tail are only available in the POSIX version of the command-line and caused an issue during startup in one check
For Solaris the POSIX tail is located in /usr/xpg4/bin/tail.



V1.9 18.12.2008

New platform support for Ubuntu 8.0.4 LTS with Domino 8.5

Disclaimer: Domino is NOT supported on Ubuntu Linux. 
But because the Notes Client 8.5 is supported and the server and the client have many components in common including the NSD scripts it should work fine.


V1.8 04.04.2008

New Features
------------

- New option "live" that can be used for "start", "stop", "restart"
  The "live" option will combine the "monitor" command for start/stop of a server
  On the console you see the script output along with the live server output
  
- New command "hang"
  generate 3 NSDs without memcheck and one additional full NSD
  this option is needed collecting troubleshooting data for server hang analysis
  
- New option DOMINO_NSD_BEFORE_KILL="yes"  
  This option will generate a NSD before finally using NSD -kill to recycle the server.

- New termination check for the live console.
  you can now type "stop" to close the live console

Problems Solved
---------------

- fixed a live console termination issue mainly on RedHat


V1.7.3 07.11.2007

Problems Solved
---------------

The cleanup option was not enabled completely. Only processes have been cleaned-up.
Semaphores, MQs and shared memory have not cleaned up because the code was still commented out.
The routine did show the info about removing those resources but did not remove the resources.

V1.7.2 16.10.2007

Problems Solved
---------------

- Setting the LC_ALL variable to the user locale after it has been set to "POSIX" 
  by the run-level scripts on SLES (see V1.7.1 fixlist) was not a good idea.
  This causes other issues with Domino, NSD and memcheck.
  This fix unsets the LC_ALL variable and ensures that the LANG variable is set correctly.
  In addition it explicitly sets LC_ALL to "POSIX" when starting NSD.
  This avoids issues with tools that have language specifc output.
  

V1.7.1 10.07.2007
-----------------

New Features
------------

- New command "cleanup"
  Remove hanging resources after a server crash
  (processes, shared memory, semaphores, message queues)

- New command "cmd"
  Issue console commands from the Unix command line
  
- New command "memdump"
  Generate a memory dump from the currently running server. 

- New command Option "stop live" to show the live console on server shutdown

- New option to remove loadmon.ncf on startup of the server via DOMINO_RESET_LOADMON="yes"

- New option to remove temp-files from data-directory on startup via DOMINO_REMOVE_TEMPFILES="yes"

- New parameter DOMINO_LOG_DIR to specify a separate directory for logging (instead of the data directory)

- New parameter DOMINO_LOG_BACKUP_DIR to specify a separate directory for backing up log files (instead of the data directory)

- Have a check that "quit" and "exit" in lower-case in monitor console mode does not shutdown the server
  You have to type in the command in uppercase to shutdown the server because "exit" and "quit" 
  are commonly used commands in a shell. Only those two reserved key-words are captured.
  All other abreviations (like "q") still work.

- New variable DOMINO_DEBUG_MODE="yes" to help debugging start-script problems 

- Crash detection on shutdown.
  The "stop" command does now monitor the server log-file for crashes during server shutdown.
  If a crash is detected the fault-recovery history is shown along with the name of the 
  generated NSD file.

- Be more SLES RC compliant and always return nice RC error status

- Updated documentation and quick documentation

Changes
-------

- Changed default location of configuration file.
  The config file for the individual servers is now located in a Linux conform standard location
  /etc/sysconfig/rc_domino_config_$DOMINO_USER
  Example: /etc/sysconfig/rc_domino_config_notes
  On AIX and Solaris you may have to create this directory.

- Rename archived log file. ".log" is now always the last part of the log-file name before the 
  time-stamp to make it easier to open the log file in text editor after decompressing.


Problems Solved
---------------

- Fixed a problem in parameter processing of the rc_domino script when running with the same account 
  (without using -su) in some environments the way the parameters are passed did not work with how 
  the shell processed them
  
  Note: you need to replace your rc_domino scripts to get this fixed
  (the rc_domino script contains some logic that cannot be moved to the rc_domino_script)
  
- Platform SLES: Fixed a problem with the LANG variable that was not properly used by the server 
  due to issues with the RC environment LC_ALL was set to "POSIX".
  This caused problems setting the locale in Domino (comma and decimal point issues).  
  Now also LC_ALL is set explicitly to avoid incorrect locale setting in Domino due to the 
  SuSE RC system. 


V1.6 10.01.2007
---------------

- Support for RHEL40 (and CentOS 4.3)
  RedHat uses "lock-files" in their RC system to keep track of started services
  This version of the script can use a lock file in /var/lock/subsys for RedHat and CentOS.
  Unfortunately files in /var/lock/subsys need root permissions to create/delete files. 
  Therefore on RedHat the start/stop/restart options need root permissions

  You have to run those scripts as "root". The script automatically switches to the 
  right Unix user name for the configured Domino partition
  
- Added information about a known issue in combination with SELinux when starting the 
  server during the runlevel setup. 


V1.5 22.05.2006
---------------

- New option to configure all settings externally in one or multiple configuration files
  Either one per partition or a general config file, separated from the script logic

- Most companies using the script turned out to be on Linux
  "sh" is now the default shell for Linux. AIX and Solaris administrators have to change 
  the shell in all scripts back to ksh
 
- Changed the default opt directory for Domino from /opt/lotus to /opt/ibm/lotus
  to reflect the new default for Domino 7.

- fixed a problem with NSD without memcheck (option nsd). if was calling nsd -info
  instead of nsd -nomemcheck


V1.4 02.04.2006
---------------

- Added code in rc_domino to handle a Solaris SIGHUB issue when started manually in the shell

- Added code in rc_domino to optional determine the Unix user from RC script name (link)

- "NOTES_" is reserved. Therefore all variables have been changed from "NOTES_" to "DOMINO_"

- Removed a description line in the SuSE start-script configuration to allow multiple 
  partitions started correctly using the RC package


V1.3 24.10.2005
---------------

- New DOMINO_OUTPUT_LOG and DOMINO_INPUT_FILE variables to define output and 
  input log files per partition   

- Configurable (exportable) NOTES_SHARED_DPOOLSIZE parameter per partition
  
- Start script debug variable (DOMINO_DEBUG_MODE="yes") does also enable NSD debug mode
  
- Fixed a problem on Linux where the 'ps' command was only reporting truncated
  process list entries depending on screen size
  The -w option of the ps command (on Linux only) is needed to provide a full
  list (else it is truncated after 80 chars)
  The resulting problem was that in some cases the domino_is_running function
  to report that the Domino server is not running

- New function "archivelog" for archiving the current text log-file


V1.2 15.10.2005
---------------

- Support for SuSE run-level editor in rc_domino script


---------------------
End of Change History
---------------------

