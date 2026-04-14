@echo off
title Infinity Server - Shutdown All
color 0C

echo ==============================================================
echo :::::::::::I N F I N I T Y   S H U T D O W N::::::::::::::::::
echo ==============================================================

echo.
echo [Shutdown] Signaling watchdogs to stop...
echo STOP > "Mariadb\stop_mysql_watchdog.flag"
echo STOP > "Apache\stop_apache_watchdog.flag"

echo [Shutdown] Stopping Apache...
taskkill /F /IM httpd.exe >nul 2>&1

echo [Shutdown] Stopping MariaDB...
taskkill /F /IM mysqld.exe >nul 2>&1

echo [Shutdown] Stopping Perl...
taskkill /F /IM perl.exe >nul 2>&1
taskkill /F /IM wperl.exe >nul 2>&1

echo [Shutdown] Waiting for watchdogs to exit...
timeout /t 2 >nul

echo [Shutdown] Forcing watchdog windows closed...
taskkill /F /FI "WINDOWTITLE contains watchdog_mysql" >nul 2>&1
taskkill /F /FI "WINDOWTITLE contains watchdog_apache" >nul 2>&1

echo [Shutdown] Stopping TrayIt...
taskkill /F /IM "TrayIt!.exe" >nul 2>&1

echo [Cleanup] Removing stop flags so next start works...
if exist "Mariadb\stop_mysql_watchdog.flag" del "Mariadb\stop_mysql_watchdog.flag"
if exist "Apache\stop_apache_watchdog.flag" del "Apache\stop_apache_watchdog.flag"

echo.
echo [Shutdown] All services stopped.
pause