@echo off
title APACHE_WATCHDOG
cd /d "%~dp0"
color 0B

set "ROOT=%~dp0.."
set "STOP_FLAG=%ROOT%\stop_apache_watchdog.flag"

echo ==============================================================
echo :::::::::::::::::  I N F I N I T Y   S E R V E R  ::::::::::::
echo ::                  Infinitys Apache Watchdog                ::
echo ==============================================================
echo.

:loop
if exist "%STOP_FLAG%" (
    echo [Apache] Stop flag detected at:
    echo %STOP_FLAG%
    echo Exiting watchdog...
    goto end
)

tasklist /FI "IMAGENAME eq httpd.exe" | find /I "httpd.exe" >nul
if errorlevel 1 (
    echo [Apache] Apache crashed. Restarting...
    start "" "%~dp0httpd.exe" -f "%~dp0..\conf\httpd.conf"
)

timeout /t 3 >nul
goto loop

:end
echo [Apache] Watchdog stopped.
exit