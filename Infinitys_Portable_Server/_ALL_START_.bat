@echo off
title Infinity Portable Server (Apache + MariaDB + Perl)
cd /d "%~dp0"
color 0B

REM --- AUTO CLEANUP OF STOP FLAGS ---
if exist "%~dp0Mariadb\stop_mysql_watchdog.flag" del "%~dp0Mariadb\stop_mysql_watchdog.flag"
if exist "%~dp0Apache\stop_apache_watchdog.flag" del "%~dp0Apache\stop_apache_watchdog.flag"

echo ==============================================================
echo :::::::::::::::::  I N F I N I T Y   S E R V E R  ::::::::::::
echo ::     Portable Apache + MariaDB + Strawberry Perl Loader   ::
echo ==============================================================
echo.

REM --- PERL ---
echo [Perl] Initializing Portable Strawberry Perl...
if not exist "%~dp0Perl\perl\bin\perl.exe" (
    echo ERROR: Perl not found in .\Perl\
    pause
    exit /b
)
set PERL_HOME=%~dp0Perl
set PATH=%PERL_HOME%\perl\bin;%PERL_HOME%\c\bin;%PATH%
set PERL5LIB=%PERL_HOME%\perl\lib;%PERL_HOME%\perl\vendor\lib;%PERL_HOME%\perl\site\lib
echo [Perl] Loaded from: %PERL_HOME%
echo.

REM --- MARIADB SERVER ---
echo [MySQL] Starting MariaDB Server...
start "MYSQL_MAIN" "%~dp0Mariadb\bin\mysqld.exe" --defaults-file="%~dp0Mariadb\my.ini"
echo [MySQL] MariaDB start command sent.

REM --- MARIADB WATCHDOG ---
echo [MySQL] Starting MariaDB watchdog...
start "MYSQL_WATCHDOG" "%~dp0Mariadb\bin\watchdog_mysql.bat"
echo [MySQL] Watchdog active.
echo.

REM --- APACHE MAIN SERVER ---
echo [Apache] Starting Apache Web Server...
start "APACHE_MAIN" "%~dp0Apache\bin\httpd.exe" -f "%~dp0Apache\conf\httpd.conf"
echo [Apache] Apache started.
echo.

REM --- APACHE WATCHDOG (STABLE VERSION) ---
echo [Apache] Starting Apache watchdog...
start "APACHE_WATCHDOG" "%~dp0Apache\bin\watchdog_apache.bat"
echo [Apache] Watchdog active.
echo.

echo.
echo [TrayIt] Launching TrayIt helper...
start "" "%~dp0TrayIt!"

echo --------------------------------------------------------------------------------
echo [TrayIt] You can send and hide running server windows to the tray using [TrayIt]!
echo --------------------------------------------------------------------------------
echo --------------------------------------------------------------------------------
echo  Just click on thing you wanna hide and select hide window.. Will be in tray
echo --------------------------------------------------------------------------------
echo.

echo All services launched in separate windows.
echo Close this window to exit launcher. NOT NEEDED AFTER REST LOAD
pause