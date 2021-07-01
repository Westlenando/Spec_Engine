@ECHO OFF
COLOR 0A
title Spec Engine

echo Specs display prompt

echo Press any key to start process . . .
pause >nul
echo.

:start
echo.
echo -------------
echo Computer data
echo.


echo SOFTWARE
systeminfo | findstr /c:"OS Name"
systeminfo | findstr /c:"OS Version"
systeminfo | findstr /c:"System Type"
wmic computersystem get name
echo.

echo HARDWARE
wmic baseboard get product,Manufacturer,version,serialnumber
systeminfo | findstr /c:"Total Physical Memory"
echo CPU:
wmic cpu get name
echo Connected drives:
wmic diskdrive get name,model,size
echo GPU(s):
wmic path win32_videocontroller get name
ECHO RAM sticks:
wmic memorychip where "devicelocator != 'SYSTEM ROM'" get capacity,devicelocator,manufacturer,partnumber

echo.
echo NETWORK

echo.
echo Adapter:
wmic NIC where NetEnabled=true get Name,Speed
::echo.
echo.
echo USAGE
echo Memory Usage
set totalMem=
set availableMem=
set usedMem=
for /f "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem
Echo Total Memory: %totalMem%
Echo Used Memory: %usedMem%
setlocal enabledelayedexpansion
set Times=0
for /f "skip=1" %%p in ('wmic cpu get loadpercentage') do (
    set Cpusage!Times!=%%p
    set /A Times=!Times! + 1
)
echo Spec Engine has completed its task. Press any key to restart, or close the program.
pause >nul
cls
call :start