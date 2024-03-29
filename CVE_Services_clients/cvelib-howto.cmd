@cls
@echo off
setlocal

rem
rem Demonstration of cvelib on Windows
rem
rem A way to sleep: 'timeout 2 >nul'
rem

set cvelibConf=%USERPROFILE%\.config\cvelib.conf
set cvelibHowToConf=%USERPROFILE%\.config\cvelib-howto.conf
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
	set ESC=%%b
)
set bold=%ESC%[1m
set normal=%ESC%[0m

echo.
echo Windows demo of cvelib
echo.
echo To keep the cmd shell open when the script exits, run as:
echo.
echo   'cmd /c cvelib-howto.cmd'
echo.
echo Press: 'r' to run the proposed command or advance the script
echo        's' to skip the proposed command
echo        'q' to quit
echo.
call :runSkip
echo Reading %cvelibConf%
call :fileCheck %cvelibConf%
call :loadConf %cvelibConf%
set _CVE_API_KEY=%CVE_API_KEY%
echo.
echo Reading %cvelibHowToConf%
call :fileCheck %cvelibHowToConf%
rem check ownership and file permissions
rem cacls %USERPROFILE%\.config\cvelib.conf  | findstr /v /i \%USERNAME%
call :loadConf %cvelibHowToConf%
echo.
call :runSkip

cls
echo #
echo # 1. Versions of some things
echo #
call :runSkip
call :show "python -V"
for /f "tokens=1 delims=." %%a in ('python -V') do echo %%a | findstr /b "Python 3" >nul
if %errorlevel% neq 0 (
	echo.
	echo cvelib requires Python 3.
	exit 5
)
call :show "git --version"
call :runSkip

cls
echo #
echo # 2. Install cvelib, configure environment
echo #
call :runSkip
if exist cvelib (
	echo cvelib already exists, delete?
	echo.
	call :show "rd /s /q cvelib"
)
call :show "git clone https://github.com/RedHatProductSecurity/cvelib.git"
call :show "cd cvelib"
call :show "cd"
call :show "python -m venv venv"
call :show "call venv\Scripts\activate.bat"
call :show "python -m pip install --upgrade pip"
call :show "pip install -e ."
call :show "set CVE_ENVIRONMENT=%CVE_ENVIRONMENT%
call :show "set CVE_USER=%CVE_USER%"
call :show "set CVE_ORG=%CVE_ORG%"
call :show "set CVE_API_KEY=************************************"
set CVE_API_KEY=%_CVE_API_KEY%

if %CVE_ENVIRONMENT% neq test (
	echo %bold%WARNING: %%CVE_ENVIRONMENT%% is set to %CVE_ENVIRONMENT%, this script is only intended%normal%
	echo %bold%to run in the test environment.%normal%
	echo.
	echo Press 'r' to continue to run, 'q' to quit.
	call :runSkip
)

rem sort out user cve.exe location
rem %APPDATA%\Python\Python311-arm64\Scripts'
rem unnecessary since we're using venv
rem but here's how
rem ##for /f "tokens=1" %%a in ('python -c "import os,sysconfig;print(sysconfig.get_path('scripts',f'{os.name}_user'))"') do (
rem ##	set pyUserPath=%%a
rem ##)

cls
echo #
echo # 3. User management
echo #
call :runSkip
call :show "cve org"
call :show "cve org users"
call :show "cve user create --help"
call :show "cve user create --username %oldUserID% --name-first %oldUserNameFirst% --name-last %oldUserNameLast%"
cve user reset-key --username %oldUserID% >nul 2>&1
call :show "cve user --username %oldUserID%"
call :show "cve user update --help"
call :show "cve user update --username %oldUserID% --name-first %newUserNameFirst%"
call :show "cve user --username %oldUserID%"
call :show "cve user update --username %oldUserID% --new-username %newUserID%"
call :show "cve user --username %newUserID%"
call :show "cve user update --username %newUserID% --add-role ADMIN"
call :show "cve user --username %newUserID%"
call :show "cve user update --username %newUserID% --remove-role ADMIN"
call :show "cve user --username %newUserID%"
call :show "cve user update --username %newUserID% --mark-inactive"
call :show "cve user --username %newUserID%"
call :show "cve user update --username %newUserID% --mark-active"
call :show "cve user --username %newUserID%"
call :show "cve user reset-key --username %newUserID%"
cve user reset-key --username %newUserID% >nul 2>&1
call :runSkip

cls
echo #
echo # 4. Reservation
echo #
call :runSkip
call :show "cve list --help"
call :runSkipClear "cve list"
call :runSkipClear "cve list --state rejected"
call :runSkipClear "cve list --state published"
call :runSkipClear "cve list --state reserved"
call :runSkip
cls
echo N.B. API changes from 1.1 to 2.1 include^:
echo   'reject' --^> 'rejected'
echo   'public' --^> 'published'
call :runSkip
cls
set reserveTemp=%~n0.%RANDOM%
echo %bold%cve reserve --raw ^> %reserveTemp% ^& type %reserveTemp%%normal%
call :runSkip
if %errorlevel% equ 1 cve reserve --raw > %reserveTemp% & type %reserveTemp%
for /f "tokens=1" %%a in ('type %reserveTemp% ^| python -c "import json,sys;cve=json.load(sys.stdin);print(cve['cve_ids'][0]['cve_id'])"') do (
	set newID=%%a
)
del %reserveTemp%
call :runSkipClear "cve show %newID%"
call :runSkip

cls
echo #
echo # 5. Publication
echo #

rem
rem publish from command line
rem
call :runSkip
echo %bold%cve publish %newID% --cve-json "{\"affected\":[{\"versions\":[{\"version\":\"0\",\"status\":\"affected\",\"lessThan\":\"1.0.3\",\"versionType\":\"semver\"}],\"product\":\"Software\",\"vendor\":\"Example\"}],\"descriptions\":[{\"lang\":\"en\",\"value\":\"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is %newID%.\"}],\"references\":[{\"url\":\"https://www.example.com/security/EA-1234.html\",\"name\":\"Example Security Advisory EA-1234\"}]}"%normal%
call :runSkip
if %errorlevel% equ 1 (
	cve publish %newID% --cve-json "{\"affected\":[{\"versions\":[{\"version\":\"0\",\"status\":\"affected\",\"lessThan\":\"1.0.3\",\"versionType\":\"semver\"}],\"product\":\"Software\",\"vendor\":\"Example\"}],\"descriptions\":[{\"lang\":\"en\",\"value\":\"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is %newID%.\"}],\"references\":[{\"url\":\"https://www.example.com/security/EA-1234.html\",\"name\":\"Example Security Advisory EA-1234\"}]}"
	echo.
)
call :show "cve show %newID%"
call :runskipClear "cve show --show-record %newID%"
call :runSkip
cls
echo %bold%cve publish %newID% --cve-json "{\"affected\":[{\"versions\":[{\"version\":\"0\",\"status\":\"affected\",\"lessThan\":\"1.0.3\",\"versionType\":\"semver\"}],\"product\":\"Software\",\"vendor\":\"Example\"}],\"descriptions\":[{\"lang\":\"en\",\"value\":\"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is %newID%, with a recent update.\"}],\"references\":[{\"url\":\"https://www.example.com/security/EA-1234.html\",\"name\":\"Example Security Advisory EA-1234\"}]}"%normal%
call :runSkip
if %errorlevel% equ 1 (
	cve publish %newID% --cve-json "{\"affected\":[{\"versions\":[{\"version\":\"0\",\"status\":\"affected\",\"lessThan\":\"1.0.3\",\"versionType\":\"semver\"}],\"product\":\"Software\",\"vendor\":\"Example\"}],\"descriptions\":[{\"lang\":\"en\",\"value\":\"Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is %newID%, with a recent update.\"}],\"references\":[{\"url\":\"https://www.example.com/security/EA-1234.html\",\"name\":\"Example Security Advisory EA-1234\"}]}"
	echo.
)
call :runskipClear "cve show --show-record %newID%"

rem
rem publish from file
rem
set publishTemp=%~n0.%RANDOM%
> %publishTemp% (
@echo.{
@echo.    "affected": [
@echo.        {
@echo.            "product": "Software",
@echo.            "vendor": "Example",
@echo.            "versions": [
@echo.                {
@echo.                    "lessThan": "1.0.3",
@echo.                    "status": "affected",
@echo.                    "version": "0",
@echo.                    "versionType": "semver"
@echo.                }
@echo.           ]
@echo.        }
@echo.    ],
@echo.    "descriptions": [
@echo.        {
@echo.            "lang": "en",
@echo.            "value": "Example Software prior to 1.0.3 has a vulnerability, using cvelib, this is %newID%, with another update, using --cve-json-file %publishTemp%."
@echo.        }
@echo.    ],
@echo.    "references": [
@echo.        {
@echo.            "name": "Example Security Advisory EA-1234",
@echo.            "url": "https://www.example.com/security/EA-1234.html"
@echo.        }
@echo.    ]
@echo.}
)
call :runSkipClear "type %publishTemp%"
call :runSkipClear "cve publish %newID% --cve-json-file %publishTemp%"
del %publishTemp%
call :runskipClear "cve show --show-record %newID%"

call :show "call venv\Scripts\deactivate.bat"
cls
goto :fin

:fin
echo Thanks Red Hat!
echo.
echo ^<https://github.com/RedHatProductSecurity/cvelib^>
echo.
echo ^<https://github.com/zmanion/CVE^>
echo.
echo Fin
echo.
exit /b 0

rem
rem "functions" 
rem

:fileCheck
if not exist %1 (
	echo.
	echo File %1 not found.
	exit 6
)
exit /b 0

:loadConf
for /f "tokens=1-2 delims== eol=#" %%a in (%1) do (
	set %%a=%%b
)
exit /b 0

:runSkipClear
rem pause >nul
call :runSkip
cls
call :show %1
exit /b 0

:show
echo %bold%%~1%normal%

:runSkip
choice /c rsq /n >nul
if %errorlevel%==1 (
	%~1
	IF ERRORLEVEL 9009 (
		rem echo.
		rem echo ERRORLEVEL is ^>=9009, likely the command was not found.
		exit 7
	)
	echo.
	exit /b 1
)
if %errorlevel%==2 (
	echo Skipping command
	echo.
	exit /b 2
)
if %errorlevel%==3 (
	echo.
	echo Quitting
	exit 3
)
goto :runSkip
