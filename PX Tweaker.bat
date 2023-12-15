@echo off
title PX Tweaker 0.1
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
echo 6. Restart ( To Apply Changes )

set /p choice=Enter your choice (1-6): 

if "%choice%"=="0" goto RestorePoint
if "%choice%"=="1" goto scanpc
if "%choice%"=="2" goto adjustPowerPlan
if "%choice%"=="3" goto clean
if "%choice%"=="4" goto disableuncessarly
if "%choice%"=="5" goto Cortona
if "%choice%"=="6" goto Restart

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

:Restart
shutdown /r /t 0
echo Restarting...
pause