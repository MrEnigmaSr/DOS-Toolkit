::     DOS Toolkit       ::
::     By Chaoddity      ::
::    August 29, 2018    ::
::     Version 2.0       ::

::Change Window Settings::
set programname=DOS Toolkit
pushd %~dp0

::Variables?::
:: a section like this is only useful if you have variables to set that you want
:: to set in the beginning.

::Cleanup::
@ECHO off
cls
COLOR 08

::Main Menu::
::==================================================================================
:mainmenu
cls
::quick intro
ECHO.
ECHO     ))~~~~~~~~~~~~~~~~~~~((
ECHO    (o   DOS TOOLKIT 2.0   o)
ECHO     ))~~~~~~~~~~~~~~~~~~~((
ECHO     Made by Chaoddity
:: Age counter?  (takes date created and gives you the number of days old it is)
ECHO.
ECHO  )~~~~~~~~~~
ECHO (  1- OS Commands
ECHO  ) 2- Net Commands
ECHO (  3- Useful Directories
ECHO  ) 4- System Tools
ECHO (  
ECHO  ) 5- About
ECHO (  6- Exit
ECHO  )~~~~~~~~~~
ECHO.

::cleared first to prevent people from just hitting enter.
::the second part is where you enter your selection.
SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO oscmd
IF "%A%"=="2" GOTO netcmd
IF "%A%"=="3" GOTO g8ddir
IF "%A%"=="4" GOTO syst8l
IF "%A%"=="5" ECHO.
IF "%A%"=="5" ECHO This program is meant to make computer troubleshooting
IF "%A%"=="5" ECHO as easy as humanly possible.
IF "%A%"=="5" ECHO All you have to do is follow the prompts.
IF "%A%"=="5" ECHO.
IF "%A%"=="5" PAUSE
IF "%A%"=="5" GOTO mainmenu
IF "%A%"=="6" EXIT
IF "%A%" GEQ 7 (
	IF "%A%" LEQ 0 (
		cls
		GOTO mainmenu
	) ELSE (
		cls
		GOTO mainmenu
	)
) ELSE (
		cls
		GOTO mainmenu
)

::===========================================================================================
::OS Commands::
:oscmd

cls
ECHO.
ECHO :  1- Time and Date
ECHO :  2- Dump process list
ECHO :  3- Quick System Info
ECHO :  4- User Accounts
ECHO :  5- User Account Edit
ECHO.
ECHO :  6- Menu 2
ECHO.

SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO timdat
IF "%A%"=="2" GOTO processlist
IF "%A%"=="3" GOTO syst
IF "%A%"=="4" GOTO users
IF "%A%"=="5" GOTO usedit
IF "%A%"=="6" GOTO oscmd2
IF "%A%" GTR 6 (
	IF "%A%" LEQ 0 (
		cls
		GOTO oscmd
	) ELSE (
		cls
		GOTO oscmd
	)
) ELSE (
		cls
		GOTO oscmd
)

::------------------------
:timdat
ECHO.
ECHO It is currently
@echo off &setlocal

for /f "tokens=1-3 delims=:,. " %%A in ("%time%") do (
  set "Hour=%%A"
  set "Min=%%B"
  set "Sec=%%C"
)

set /a Hour = Hour %% 12
if %Hour%==0 set "Hour=12"

set "Allm=%Hour%:%Min%;%Sec%"

echo %Allm% 
echo %date%
echo.
pause

goto oscmd

::------------------------
:processlist
tasklist /v > "%USERPROFILE%\desktop\Process.txt"
echo The file is on your desktop!
pause
goto oscmd

::------------------------
:syst
setlocal enableextensions enabledelayedexpansion
for /f "delims=" %%l in ('wmic computersystem get Manufacturer^,Model^,SystemType^,TotalPhysicalMemory /format:list') do >nul 2>&1 set "System_%%l"
for /f "delims=" %%l in ('wmic cpu get * /format:list') do >nul 2>&1 set "CPU_%%l"
for /f "delims=" %%l in ('wmic os get FreePhysicalMemory^,TotalVisibleMemorySize /format:list') do >nul 2>&1 set "OS_%%l"
set /a OS_UsedPhysicalMemory=OS_TotalVisibleMemorySize-OS_FreePhysicalMemory

for /f "delims=" %%l in ('wmic volume get DriveLetter^,FreeSpace /format:list') do (
    >nul 2>&1 set "TEMP_%%l"
    if "!TEMP_DriveLetter:~1,1!"==":" if defined TEMP_FreeSpace set StorageSpace_!TEMP_DriveLetter:~0,2!=!TEMP_FreeSpace:~0,-1!&set TEMP_DriveLetter=&set TEMP_FreeSpace=
)

echo.
echo Manufacturer: %System_Manufacturer%
echo Model: %System_Model%
echo Processor Type: %PROCESSOR_ARCHITECTURE%
echo Processor Size: %CPU_AddressWidth%
echo System Type: %System_SystemType%
echo Storage Space:
set StorageSpace_
echo RAM total: %OS_TotalVisibleMemorySize% kb
echo RAM free: %OS_FreePhysicalMemory% kb
echo RAM used: %OS_UsedPhysicalMemory% kb
pause

goto oscmd

::------------------------
:users

net user
ECHO.
SET "A="
SET /P A=Do you want details for any of these accounts?(y/n)  
ECHO.
IF "%A%"=="y" (
		GOTO check
	) ELSE (
		goto oscmd
	)

:check
SET "NAM="
SET /P NAM=What account? 
ECHO.
net user %NAM%
pause
goto oscmd

::------------------------ 
:usedit
ECHO ===================================
net help user
ECHO ====================================
start cmd.exe
pause
::(open in a new window)
goto oscmd

::===========================================================================================
::OS Commands2::
:oscmd2

cls
ECHO.

ECHO :  1- Check Disk
ECHO         (This runs at startup)
ECHO :  2- SFC Repair Tool
ECHO         (this usually requires a windows disc)
ECHO :  3- DISM Repair Tool
ECHO         (this requires internet)
ECHO.
ECHO :  4- Return
ECHO.

SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO chkdsk
IF "%A%"=="2" GOTO sfcscan
IF "%A%"=="3" GOTO dism
IF "%A%"=="4" GOTO mainmenu
IF "%A%" GTR 4 (
	IF "%A%" LEQ 0 (
		cls
		GOTO oscmd2
	) ELSE (
		cls
		GOTO oscmd2
	)
) ELSE (
		cls
		GOTO oscmd2
)

::------------------------
:chkdsk
SET "CHOSEN="
SET /P CHOSEN=Choose a disk drive:
powershell -Command "Start-Process cmd \"/k  chkdsk %CHOSEN%: /r   \" -Verb RunAs"
ECHO           Your CHKDSK has been opened in another window
ECHO         with elevated permissions, for your convenience
pause
goto oscmd

::------------------------
:sfcscan
powershell -Command "Start-Process cmd \"/k  sfc /scannow  \" -Verb RunAs"
ECHO           Your SFC has been opened in another window
ECHO         with elevated permissions, for your convenience
goto oscmd

::------------------------
:dism
powershell -Command "Start-Process cmd \"/k  DISM /Online /Cleanup-Image /RestoreHealth  \" -Verb RunAs"
ECHO           Your DISM has been opened in another window
ECHO         with elevated permissions, for your convenience
pause
goto oscmd


::========================================================================================
::Net Commands::
:netcmd

cls
ECHO.
ECHO :  1- Ping
ECHO         (opens in a new window)
ECHO :  2- Infini-ping
ECHO         (opens in a new window)
ECHO :  3- Trace Route
ECHO         (opens in a new window)
ECHO :  4- Active connections 
ECHO         (opens in a new window)
ECHO :  5- Domain View
ECHO :  6- ARP
ECHO         (view all IPs on network)
ECHO :  7- Adapter Details
ECHO :  8- LAN view
ECHO.
ECHO :  9- Menu 2
ECHO.

SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO png
IF "%A%"=="2" GOTO png2
IF "%A%"=="3" GOTO trcrt
IF "%A%"=="4" GOTO actcon
IF "%A%"=="5" GOTO domvw
IF "%A%"=="6" GOTO arp
IF "%A%"=="7" GOTO condet
IF "%A%"=="8" GOTO shares
IF "%A%"=="9" GOTO netcmd2
IF "%A%" GTR 9 (
	IF "%A%" LEQ 0 (
		cls
		GOTO netcmd
	) ELSE (
		cls
		GOTO netcmd
	)
) ELSE (
		cls
		GOTO netcmd
)

::------------------------
:png
SET "CHOSEN="
SET /P CHOSEN=Enter an IP address: 
start cmd.exe /c "ping %CHOSEN% & pause"
goto netcmd

::------------------------
:png2
SET "CHOSEN="
SET /P CHOSEN=Enter an IP address: 
start cmd.exe /c "ping %CHOSEN% -t & pause"
goto netcmd

::------------------------
:trcrt
SET "CHOSEN="
SET /P CHOSEN=Enter an IP address: 
start cmd.exe /c "tracert %CHOSEN% & pause"
goto netcmd

::------------------------
:actcon
start cmd.exe /c "netstat & pause"
goto netcmd

::------------------------
:domvw
net view
pause
goto netcmd

::--------------------------
:arp
arp -a
pause
goto netcmd

::------------------------
:condet
ipconfig /all
pause
goto netcmd

::------------------------
:shares
ECHO All who have file and print sharing enabled on network:
ECHO.
net view

ECHO All shares including administrative shares:
ECHO.
net view /all

ECHO All Domains on current network:
ECHO.
net view /domain

pause
goto netcmd

::========================================================================================
::Net Commands 2::
:netcmd2

cls
ECHO.
ECHO :  1- Domain Disconnect
ECHO :  2- DNS clean
ECHO         (release, flush dns, renew)
ECHO :  3- Reset Stack/Socket
ECHO.
ECHO :  4- Return
ECHO.

SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO domdis
IF "%A%"=="2" GOTO conres
IF "%A%"=="3" GOTO allreset
IF "%A%"=="4" GOTO mainmenu
IF "%A%" GTR 5 (
	IF "%A%" LEQ 0 (
		cls
		GOTO netcmd2
	) ELSE (
		cls
		GOTO netcmd2
	)
) ELSE (
		cls
		GOTO netcmd2
)
::------------------------
:domdis
NET SESSION /DELETE /y
pause
goto netcmd

::------------------------
:conres
ipconfig /release
ipconfig /flushdns
ipconfig /registerdns
pause
goto netcmd

::------------------------
:allreset
netsh int ip reset reset.log
netsh winsock reset catalog
pause
goto netcmd

::=================================================================================
::Useful Directories::
:g8ddir

cls
ECHO.
ECHO :  1- Windows
ECHO :  2- Hosts Dir
ECHO :  3- Program Files(32)
ECHO         (this loads your 64 bit dir on 64bit)
ECHO :  4- Program Files(64)
ECHO         (this loads your 32 bit dir on 64bit)
ECHO :  5- User Profile
ECHO         (All your account saves are here!)
ECHO :  6- User Appdata
ECHO         (profiles for web browsers and java apps(minecraft) are here)
ECHO.
ECHO :  7- Return
ECHO.

SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO windo
IF "%A%"=="2" GOTO hostdir
IF "%A%"=="3" GOTO pf32
IF "%A%"=="4" GOTO pf64
IF "%A%"=="5" GOTO usepro
IF "%A%"=="6" GOTO usedata
IF "%A%"=="7" GOTO mainmenu
IF "%A%" GEQ 8 (
	IF "%A%" LEQ 0 (
		cls
		GOTO g8ddir
	) ELSE (
		cls
		GOTO g8ddir
	)
) ELSE (
		cls
		GOTO g8ddir
)

::------------------------
:windo
explorer c:\windows
goto :g8ddir

::------------------------
:hostdir
explorer C:\Windows\System32\drivers\etc
goto :g8ddir

::------------------------
:pf32
explorer C:\Program Files
goto :g8ddir

::------------------------
:pf64
explorer C:\Program Files (x86)
goto :g8ddir

::------------------------
:usepro
explorer %userprofile%
goto :g8ddir

::------------------------
:usedata
explorer %appdata%
goto :g8ddir

::===================================================================================
::System Apps::
:syst8l

cls
ECHO.
ECHO :  1- Control Panel
ECHO         (change view to small icons for more control)
ECHO :  2- Startup Control(msconfig)
ECHO :  3- Services
ECHO :  4- Registry
ECHO :  5- DirectX Info
ECHO :  6- System Info
ECHO :  7- System Logs
ECHO.
ECHO :  8- Menu 2
ECHO.

SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO ctrlpan
IF "%A%"=="2" GOTO strtup
IF "%A%"=="3" GOTO srvces
IF "%A%"=="4" GOTO rgdt
IF "%A%"=="5" GOTO dirctx
IF "%A%"=="6" GOTO systmnfo
IF "%A%"=="7" GOTO syslogs
IF "%A%"=="8" GOTO syst82
IF "%A%" GEQ 9 (
	IF "%A%" LEQ 0 (
		cls
		GOTO syst8l
	) ELSE (
		cls
		GOTO syst8l
	)
) ELSE (
		cls
		GOTO syst8l
)

::------------------------
:ctrlpan
control
GOTO syst8l

::------------------------
:strtup
msconfig
ECHO Look up the processes under startup and
ECHO uncheck the things you dont think you will need.
ECHO Dont worry- nothing but your firewall needs to run
ECHO on startup.  This is mostly preference.
ECHO You can increase startup speed this way.
ECHO.
pause
GOTO syst8l

::------------------------
:srvces
services.msc
ECHO This is only really useful if you have a problematic
ECHO service.  Helpful with troubleshooting particularly awful
ECHO programs such as Itunes and it's services.
ECHO.
pause
GOTO syst8l
::------------------------
:rgdt
regedit
ECHO Unless you have a reason to be here DO NOT EDIT.
ECHO.
pause
GOTO syst8l

::------------------------
:dirctx
dxdiag
ECHO Lets you see your video driver details and directx
ECHO functionality.
ECHO.
pause
GOTO syst8l

::------------------------
:systmnfo
msinfo32
ECHO Full system info.  Handy!
ECHO.
pause
GOTO syst8l

::------------------------
:syslogs
eventvwr
ECHO Look under windows logs.
ECHO The only two you want to concern yourself with are
ECHO APPLICATION and SYSTEM logs usually.
ECHO Look for errors and warnings.
ECHO Tip- Dont worry.  Most are normal.
ECHO.
pause
GOTO syst8l

::===============================================
:syst82

cls
ECHO :  1- Disk Cleanup
ECHO :  2- Disk Defrag
ECHO         (GET AUSLOGIC DEFRAG IF YOU HAVE NET)
ECHO :  3- Backup Drive
ECHO :  4- System Restore
ECHO.
ECHO :  5- Return
ECHO.


SET "A="
SET /P A=What do you need?  
ECHO.
IF "%A%"=="1" GOTO dskcln
IF "%A%"=="2" GOTO dskdfrg
IF "%A%"=="3" GOTO bckdrv
IF "%A%"=="4" GOTO systr
IF "%A%"=="5" GOTO mainmenu
IF "%A%" GEQ 6 (
	IF "%A%" LEQ 0 (
		cls
		GOTO syst82
	) ELSE (
		cls
		GOTO syst82
	)
) ELSE (
		cls
		GOTO syst82
)

::------------------------
:dskcln
cleanmgr
GOTO syst82

::------------------------
:dskdfrg
defrag /C
GOTO syst82

::------------------------
:bckdrv
sdclt
ECHO This utility helps back up your data.
ECHO.
pause
GOTO syst82

::------------------------
:systr
systempropertiesprotection
ECHO To save a restore point hit save.
ECHO To load hit system restore.
ECHO To change settings hit Configure.
ECHO.
pause
GOTO syst82


::loads microsoft programs that you might find useful

::TO ADD?
:: Verifier
:: Drive selection and options on checkdisk
