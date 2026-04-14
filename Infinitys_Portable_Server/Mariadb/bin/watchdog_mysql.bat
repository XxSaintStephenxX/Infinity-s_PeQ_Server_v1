@echo off
title MYSQL_WATCHDOG
cd /d "%~dp0"
color 0B

set "ROOT=%~dp0.."
set "STOP_FLAG=%ROOT%\stop_mysql_watchdog.flag"

echo ==============================================================
echo :::::::::::::::::  I N F I N I T Y   S E R V E R  ::::::::::::
echo ::                  Infinitys MariaDB Watchdog               ::
echo ==============================================================
echo.

:loop
if exist "%STOP_FLAG%" (
    echo [MySQL] Stop flag detected at:
    echo %STOP_FLAG%
    echo Exiting watchdog...
    goto end
)

tasklist /FI "IMAGENAME eq mysqld.exe" | find /I "mysqld.exe" >nul
if errorlevel 1 (
    echo [MySQL] MariaDB crashed. Restarting...
    start "" "%~dp0mysqld.exe" --defaults-file="%~dp0..\my.ini"
)

timeout /t 3 >nul
goto loop

:end
echo [MySQL] Watchdog stopped.
exit