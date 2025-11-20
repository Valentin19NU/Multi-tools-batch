@echo off
color 3
title Multi-tools-batch

:start
cls
echo ===============================================
echo                Multi-Tools Panel
echo ===============================================
echo 1 - Check internet connection
echo 2 - Clean temporary files
echo 3 - Save a file to a USB drive
echo 4 - Generate a random password
echo 5 - Compress a folder
echo 6 - Show CPU / RAM usage
echo 7 - Quick restart / shutdown
echo 0 - Exit tool
echo ===============================================
echo.
set "choiceinput="
set /p choiceinput=Please choose an option : 
echo.

if "%choiceinput%"=="1" goto choice1
if "%choiceinput%"=="2" goto choice2
if "%choiceinput%"=="3" goto choice3
if "%choiceinput%"=="4" goto choice4
if "%choiceinput%"=="5" goto choice5
if "%choiceinput%"=="6" goto choice6
if "%choiceinput%"=="7" goto choice7
if "%choiceinput%"=="0" goto exitTool
goto start

:exitTool
exit

:: 1 - Check Internet connection
:choice1
cls
echo A ping test will be performed. Press any key to continue.
pause >nul
cls
ping -n 1 www.google.com >nul
if %errorlevel%==0 goto internetOK
goto internetKO

:internetOK
cls
echo Internet connection: OK
timeout /t 3 >nul
goto start

:internetKO
cls
echo No internet connection detected. Please check your network.
timeout /t 5 >nul
goto start

:: 2 - Clean temporary files
:choice2
cls
echo Cleaning temporary files...
del /s /f /q "%TEMP%\*.*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1
PowerShell.exe -Command "Clear-RecycleBin -Force" >nul 2>&1
echo Cleaning completed!
pause >nul
goto start

:: 3 - Backup file to USB
:choice3
cls
set "USB_NAME=USBDrive"
set /p FILE_SOURCE=Enter the full path of the file to save: 

if not exist "%FILE_SOURCE%" (
    echo File not found.
    pause >nul
    goto start
)

set "USB_DRIVE="
for /f "tokens=1,2*" %%i in ('wmic logicaldisk get name^, volumename ^| findstr /R /C:"[A-Z]:"') do (
    if /i "%%k"=="%USB_NAME%" set "USB_DRIVE=%%i"
)

if not defined USB_DRIVE (
    echo USB drive "%USB_NAME%" not detected.
    pause >nul
    goto start
)

echo USB drive detected on %USB_DRIVE%
echo Copying file...
copy "%FILE_SOURCE%" "%USB_DRIVE%\" /Y >nul

if %errorlevel%==0 (
    echo File successfully saved!
) else (
    echo Error during file copy.
)

pause >nul
goto start

:: 4 - Generate random password
:choice4
cls
set /p length=Enter password length (default 12): 
if "%length%"=="" set length=12

set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"

set "password="

:generateLoop
set /a rnd=%random% %% 70
for %%A in (!chars!) do (
    set "char=!chars:~%rnd%,1!"
)
set "password=%password%%char%"
set /a count+=1
if %count% LSS %length% goto generateLoop

cls
echo Generated password:
echo %password%
set count=
pause >nul
goto start

:: 5 - Compress folder
:choice5
cls
set /p folder=Enter the folder path to compress: 
if not exist "%folder%" (
    echo Folder not found.
    pause >nul
    goto start
)

set /p zipname=Enter output ZIP name (without .zip): 

PowerShell.exe -Command "Compress-Archive -Path '%folder%' -DestinationPath '%cd%\%zipname%.zip'" 2>nul

cls
echo Compression completed: %zipname%.zip
pause >nul
goto start

:: 6 - Show CPU / RAM usage
:choice6
cls
echo CPU and RAM usage:
echo =====================
wmic cpu get loadpercentage
echo.
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Format:Table
pause >nul
goto start

:: 7 - Quick restart / shutdown
:choice7
cls
echo 1 - Restart computer
echo 2 - Shutdown computer
echo 0 - Cancel
set /p powerChoice=Choose an option: 

if "%powerChoice%"=="1" shutdown /r /t 0
if "%powerChoice%"=="2" shutdown /s /t 0
goto start


goto start
