@echo off
title PX Tweaker 1.0 Release! Made By qtkn
cls

:menu
echo ================================
echo PX Tweaker Options
echo ================================
echo 0. Create A Restore Point
echo 1. Scan The PC
echo 2. High Performance Power Plan
echo 3. Clean Temporary Files
echo 4. Disable unnecessary services
echo 5. Disable Cortona
echo 6. Fix Ping Issues
echo 7. Optimize Windows Services
echo 8. Disable Windows 10 Telemetry
echo 9. Disable Windows 11 Telemetry
echo 10. Optimize Registry
echo 11. Disable Windows Search Indexing
echo 12. Optimize Visual Effects
echo 13. Optimize Windows 11/10 Boot Time
echo 14. Mouse And Keyboard Optimization
echo 15. Restart ( To Apply Changes )

set /p choice=Enter your choice (1-10): 

if "%choice%"=="0" goto RestorePoint
if "%choice%"=="1" goto scanpc
if "%choice%"=="2" goto adjustPowerPlan
if "%choice%"=="3" goto clean
if "%choice%"=="4" goto disableuncessarly
if "%choice%"=="5" goto Cortona
if "%choice%"=="6" goto ping
if "%choice%"=="7" goto optimizewindowsservices
if "%choice%"=="8" goto win10telemetry
if "%choice%"=="9" goto win11telemetry
if "%choice%"=="10" goto optimizeregistry
if "%choice%"=="11" goto searchindex
if "%choice%"=="12" goto optimizevisuals
if "%choice%"=="13" goto boottime
if "%choice%"=="14" goto mouseandkb
if "%choice%"=="15" goto Restart

echo Invalid choice. Please try again.
goto menu

:RestorePoint
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'PX Restore Point' >nul 2>&1
echo Created Restore Point Successfully
goto menu

:scanpc
:: sfc /scannow
chkdsk /f
systeminfo
wuauclt /detectnow
echo Scanned Your PC Successfully
goto menu

:adjustPowerPlan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
echo Adjusting power plan...
goto menu

:clean
set folder="C:\Windows\Temp"
cd /d %folder%
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
cls

REM Delete temporary files from the user's local AppData\Temp directory
set folder="%userprofile%\AppData\Local\Temp"
cd /d %folder%
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
cls

REM Use the Disk Cleanup tool to automatically clean up various types of files
@echo AUTOMATIC DISK CLEANUP
set R_Key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches
reg add "%R_Key%\Active Setup Temp Folders" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Thumbnail Cache" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Delivery Optimization Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\D3D Shader Cache" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Downloaded Program Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Internet Cache Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Setup Log Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Temporary Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Windows Error Reporting Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
reg add "%R_Key%\Offline Pages Files" /v StateFlags0011 /t REG_DWORD /d 00000002 /f
cleanmgr.exe /sagerun:11
del /q /s %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
echo Cleaned Successfully
goto menu

:disableuncessarly
sc config "DiagTrack" start=disabled
sc stop "DiagTrack"
sc config "wuauserv" start=disabled
sc stop "wuauserv"
sc config "wercplsupport" start=disabled
sc stop "wercplsupport"
sc config "sppsvc" start=disabled
sc stop "sppsvc"
echo Disabled Unnecessary Services Successfully
goto menu

:Cortona
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f 
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "0" /f 


chcp 431 >nul 
Powershell -Command "Get-appxpackage -allusers *Microsoft.549981C3F5F10* | Remove-AppxPackage" 
echo Disabled Cortona Successfully
goto menu

:ping
REM Flush DNS Cache
ipconfig /flushdns


REM Release and Renew IP Configuration
ipconfig /release
ipconfig /renew


REM Reset Winsock
netsh winsock reset


REM Reset TCP/IP stack
netsh int ip reset

netsh int tcp set global autotuninglevel=normal
netsh int tcp set heuristics disabled
netsh int tcp set global chimney=enabled
netsh int tcp set global rss=enabled

echo Ping issues may be resolved. Please check your connection.
goto menu

:optimizewindowsservices
netsh advfirewall set allprofiles state off
netsh interface tcp set global autotuning=disabled
netsh int tcp set heuristics disabled
netsh int tcp set global chimney=disabled
netsh int tcp set global rss=enabled
netsh int tcp show global
echo Windows services optimized.
goto menu

:win10telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
echo Windows 10 telemetry disabled.
goto menu

:win11telemetry
sc stop DiagTrack
sc config DiagTrack start=disabled
sc stop dmwappushservice
sc config dmwappushservice start=disabled
sc stop Wecsvc
sc config Wecsvc start=disabled
echo Windows 11 telemetry disabled.
goto menu

:optimizeregistry
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v Max Cached Icons /t REG_SZ /d 2048 /f
reg add HKCU\Control Panel\Desktop /v MenuShowDelay /t REG_SZ /d 150 /f
echo Registry optimized.
goto menu

:searchindex
sc config WSearch start=disabled
net stop WSearch
echo Windows Search Indexing disabled.
goto menu

:optimizevisuals
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f
echo Visual effects optimized for performance.
goto menu

:boottime
bcdedit /set useplatformclock true
powercfg /hibernate off
echo Windows boot time optimized.
goto menu

:mouseandkb
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 50 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "ConnectMultiplePorts" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDeviceBaseName" /t REG_SZ /d "KeyboardClass" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "MaximumPortsServiced" /t REG_DWORD /d 3 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "SendOutputToAllPorts" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "WppRecorder_TraceGuid" /t REG_SZ /d "{09281f1f-f66e-485a-99a2-91638f782c49}" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 50 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "WppRecorder_TraceGuid" /t REG_SZ /d "{fc8df8fd-d105-40a9-af75-2eec294adf8d}" /f
echo Mouse And Keyboard optimized.
goto menu

:Restart
shutdown /r /t 0
echo Restarting...
pause
