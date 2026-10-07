@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Request administrator rights.
fltmc >nul 2>&1
if errorlevel 1 (
    powershell.exe -NoProfile -Command "Start-Process '%~sdpnx0' -Verb RunAs"
    exit /b 0
)

set "SCRIPT_DIR=%~dp0"
set "SERVICE_NAME=LecooControlDaemon"
set "DAEMON_EXE=lecoo-ec-daemon.exe"
set "INSTALL_DIR=%ProgramFiles%\LecooControlCenter"
set "CTRL_EXE=%INSTALL_DIR%\lecoo-ctrl.exe"
set "REPO_API=https://api.github.com/repos/LaVashikk/Lecoo-Control-Center/releases?per_page=100"
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

cd /d "%SCRIPT_DIR%" >nul 2>&1

if /i "%~1"=="install" goto :update
if /i "%~1"=="update" goto :update
if /i "%~1"=="repair" goto :repair
if /i "%~1"=="uninstall" goto :uninstall
if "%~1"=="1" goto :update
if "%~1"=="2" goto :repair
if "%~1"=="3" goto :uninstall

:menu
cls
echo.
echo ============================================================
echo   Lecoo Control Center Manager
echo ============================================================
echo.
echo "This tool can install, update, repair, or uninstall the Lecoo Control Center."
echo "Original repository: https://github.com/LaVashikk/Lecoo-Control-Center (MIT License)"
echo "This is third-party install script, NOT official."
echo.
echo   [1] Install or update
echo   [2] Repair service
echo   [3] Uninstall
echo   [Q] Exit
echo.
choice /c 123Q /n /m "Select an action: "
if errorlevel 4 exit /b 0
if errorlevel 3 goto :uninstall
if errorlevel 2 goto :repair
if errorlevel 1 goto :update
exit /b 0

:update
call :update_impl
set "RC=%errorlevel%"
if not "%RC%"=="0" echo Operation failed with code %RC%.
echo.
pause
exit /b %RC%

:update_impl
set "UPDATE_DIR=%TEMP%\Lecoo-Ctrl-Manager"
set "PACKAGE_DIR=%UPDATE_DIR%\package"
set "ZIP_FILE=%UPDATE_DIR%\release.zip"
set "INFO_FILE=%UPDATE_DIR%\installed.txt"
set "META_FILE=%UPDATE_DIR%\release.txt"
set "ERROR_FILE=%UPDATE_DIR%\error.txt"
set "CURRENT_VERSION="
set "LATEST_TAG="
set "LATEST_VERSION="
set "LATEST_PRERELEASE="
set "PACKAGE_NAME="
set "PACKAGE_URL="

call :cleanup_update
mkdir "%PACKAGE_DIR%" >nul 2>&1
if not exist "%PACKAGE_DIR%" (
    echo [FAIL] Cannot create temporary package directory.
    exit /b 1
)

echo.
echo ============================================================
echo   Install or update
echo ============================================================
echo [1/4] Checking the installed version...

if not exist "%CTRL_EXE%" set "CTRL_EXE="
if not defined CTRL_EXE (
    for /f "delims=" %%P in ('%SystemRoot%\System32\where.exe lecoo-ctrl 2^>nul') do if not defined CTRL_EXE set "CTRL_EXE=%%P"
)

if defined CTRL_EXE (
    "%CTRL_EXE%" info >"%INFO_FILE%" 2>&1
    if not errorlevel 1 (
        for /f "usebackq delims=" %%V in (`%PS% -NoProfile -ExecutionPolicy Bypass -Command "$s=Get-Content -Raw -LiteralPath '%INFO_FILE%'; $m=[regex]::Match($s,'\d+\.\d+\.\d+(?:\.\d+)?'); if($m.Success){$m.Value}"`) do if not defined CURRENT_VERSION set "CURRENT_VERSION=%%V"
    )
)

if defined CURRENT_VERSION (
    echo       Installed version: %CURRENT_VERSION%
) else (
    echo       lecoo-ctrl is not installed.
)

echo [2/4] Checking GitHub releases...
%PS% -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$releases=Invoke-RestMethod -UseBasicParsing -Headers @{'User-Agent'='LecooControlCenter-Manager'} -Uri '%REPO_API%';" ^
 "$r=$null; $releaseDate=[datetime]::MinValue;" ^
 "foreach($candidate in $releases){ if((-not $candidate.draft) -and $candidate.published_at){ $d=[datetime]$candidate.published_at; if($d -gt $releaseDate){$r=$candidate;$releaseDate=$d} } };" ^
 "if($null -eq $r){throw 'No published GitHub release found.'};" ^
 "$a=$null; $best=-1;" ^
 "foreach($x in $r.assets){ if($x.name -match '(?i)\.zip$' -and $x.name -notmatch '(?i)(source|checksum|sha256)'){ $score=0; if($x.name -match '(?i)(windows|win)'){$score+=4}; if($x.name -match '(?i)(x64|amd64)'){$score+=2}; if($score -gt $best){$a=$x;$best=$score} } };" ^
 "if(($null -eq $a) -or ($best -lt 4)){throw 'No Windows ZIP asset found in the latest release.'};" ^
 "Set-Content -LiteralPath '%META_FILE%' -Value ($r.tag_name + '|' + $r.prerelease + '|' + $a.name + '|' + $a.browser_download_url) -Encoding ASCII" >nul 2>"%ERROR_FILE%"
if errorlevel 1 (
    echo [FAIL] Could not query GitHub releases.
    type "%ERROR_FILE%" 2>nul
    goto :update_failed
)

for /f "usebackq tokens=1-4 delims=|" %%A in ("%META_FILE%") do (
    set "LATEST_TAG=%%A"
    set "LATEST_PRERELEASE=%%B"
    set "PACKAGE_NAME=%%C"
    set "PACKAGE_URL=%%D"
)
set "LATEST_VERSION=%LATEST_TAG:v=%"
for /f "tokens=1 delims=-+" %%V in ("%LATEST_VERSION%") do set "LATEST_VERSION=%%V"
if not defined LATEST_VERSION (
    echo [FAIL] Release tag has no semantic version: %LATEST_TAG%
    goto :update_failed
)
if /i "%LATEST_PRERELEASE%"=="True" (
    echo       Latest version: %LATEST_VERSION% - pre-release
) else (
    echo       Latest version: %LATEST_VERSION% - stable
)

if defined CURRENT_VERSION (
    %PS% -NoProfile -ExecutionPolicy Bypass -Command "$c=[version]'%CURRENT_VERSION%'; $l=[version]'%LATEST_VERSION%'; if($c -lt $l){exit 10}"
    if errorlevel 10 (
        echo       A newer version is available.
    ) else if errorlevel 1 (
        echo [FAIL] Could not compare versions.
        goto :update_failed
    ) else (
        echo       Already up to date.
        goto :update_success
    )
) else (
    echo       Installation is required.
)

echo [3/4] Downloading and extracting the package...
set "LECOO_URL=%PACKAGE_URL%"
set "LECOO_ZIP=%ZIP_FILE%"
set "LECOO_EXTRACT=%PACKAGE_DIR%"
%PS% -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Invoke-WebRequest -UseBasicParsing -Uri $env:LECOO_URL -OutFile $env:LECOO_ZIP; Expand-Archive -LiteralPath $env:LECOO_ZIP -DestinationPath $env:LECOO_EXTRACT -Force" >nul 2>"%ERROR_FILE%"
if errorlevel 1 (
    echo [FAIL] Download or extraction failed.
    type "%ERROR_FILE%" 2>nul
    goto :update_failed
)

set "INSTALL_SCRIPT="
for /r "%PACKAGE_DIR%" %%F in (install.bat) do if not defined INSTALL_SCRIPT set "INSTALL_SCRIPT=%%F"
if not defined INSTALL_SCRIPT (
    echo [FAIL] The package does not contain install.bat.
    goto :update_failed
)

echo [4/4] Running the package installer...
for %%F in ("%INSTALL_SCRIPT%") do pushd "%%~dpF"
call "%INSTALL_SCRIPT%"
set "INSTALL_RC=%errorlevel%"
popd
if not "%INSTALL_RC%"=="0" (
    echo [FAIL] install.bat returned code %INSTALL_RC%.
    goto :update_failed
)
echo       Installation completed.
goto :update_success

:update_success
call :cleanup_update
exit /b 0

:update_failed
call :cleanup_update
exit /b 1

:cleanup_update
if defined UPDATE_DIR if exist "%UPDATE_DIR%" rmdir /s /q "%UPDATE_DIR%" >nul 2>&1
exit /b 0

:repair
call :repair_impl
set "RC=%errorlevel%"
if not "%RC%"=="0" echo Operation failed with code %RC%.
echo.
pause
exit /b %RC%

:repair_impl
echo.
echo ============================================================
echo   Repair service
echo ============================================================
%SystemRoot%\System32\sc.exe query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Service "%SERVICE_NAME%" does not exist.
    exit /b 1
)

echo Waiting for "%SERVICE_NAME%" to run...
:repair_loop
%SystemRoot%\System32\sc.exe query "%SERVICE_NAME%" 2>nul | %SystemRoot%\System32\find.exe /I "RUNNING" >nul 2>&1
if not errorlevel 1 (
    echo       Service is running.
    exit /b 0
)
%SystemRoot%\System32\sc.exe query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Service disappeared.
    exit /b 1
)
%SystemRoot%\System32\sc.exe start "%SERVICE_NAME%" >nul 2>&1
%SystemRoot%\System32\timeout.exe /t 5 /nobreak >nul
goto :repair_loop

:uninstall
call :uninstall_impl
set "RC=%errorlevel%"
if not "%RC%"=="0" echo Operation failed with code %RC%.
echo.
pause
exit /b %RC%

:uninstall_impl
echo.
echo ============================================================
echo   Uninstall
echo ============================================================

echo [1/4] Stopping service...
%SystemRoot%\System32\sc.exe query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 (
    echo       Service not found.
    goto :uninstall_kill_process
)
%SystemRoot%\System32\sc.exe stop "%SERVICE_NAME%" >nul 2>&1
set "WAIT_COUNT=0"
:uninstall_wait_stop
%SystemRoot%\System32\sc.exe query "%SERVICE_NAME%" 2>nul | %SystemRoot%\System32\find.exe /I "STOPPED" >nul 2>&1
if not errorlevel 1 goto :uninstall_stopped
set /a WAIT_COUNT+=1
if !WAIT_COUNT! geq 15 (
    echo       Timed out waiting for service.
    goto :uninstall_stopped
)
%SystemRoot%\System32\timeout.exe /t 1 /nobreak >nul
goto :uninstall_wait_stop

:uninstall_stopped
%SystemRoot%\System32\sc.exe delete "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 (echo       Could not delete service.) else (echo       Service removed.)
%SystemRoot%\System32\timeout.exe /t 2 /nobreak >nul

:uninstall_kill_process
echo [2/4] Stopping processes...
tasklist /FI "IMAGENAME eq %DAEMON_EXE%" 2>nul | %SystemRoot%\System32\find.exe /I "%DAEMON_EXE%" >nul 2>&1
if not errorlevel 1 taskkill /F /IM "%DAEMON_EXE%" >nul 2>&1
echo       Done.

echo [3/4] Removing the system PATH entry...
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -EP Bypass -Command "$d='%INSTALL_DIR%';$o=[Environment]::GetEnvironmentVariable('Path','Machine');if($o){$n=($o-split';'|?{$_ -and $_.TrimEnd('\')-ne$d.TrimEnd('\')})-join';';[Environment]::SetEnvironmentVariable('Path',$n,'Machine')}" 2>nul
if errorlevel 1 (echo       Could not update PATH.) else (echo       Done.)

echo [4/4] Removing files...
if not exist "%INSTALL_DIR%" (
    echo       Directory not found.
    goto :uninstall_success
)
rmdir /s /q "%INSTALL_DIR%" >nul 2>&1
if exist "%INSTALL_DIR%" (echo       Some files are locked.) else (echo       Files removed.)

:uninstall_success
echo.
echo Uninstallation completed.
exit /b 0
