@echo off
setlocal enabledelayedexpansion

echo =======================================================================
echo   Teams Cache Cleanup Utility
echo.
echo   This will:
echo     - Close Outlook and other Office apps
echo     - Clear Microsoft Teams cache
echo     - Restart Teams and any closed apps
echo     - Optionally restart the computer
echo.
echo   Save any work before continuing or close this window to exit.
echo =======================================================================
echo.
pause

set "apps="
set "logfile=%TEMP%\TeamsCleanup.log"
echo [%date% %time%] Starting Teams Cleanup >> "%logfile%"

echo.
<nul set /p="Detecting running Office and Teams apps... "

for %%p in (outlook.exe winword.exe excel.exe powerpnt.exe onenote.exe msaccess.exe ms-teams.exe) do (
    tasklist /fi "imagename eq %%p" | find /i "%%p" >nul && (
        set "apps=!apps! %%p"
    )
)

echo done.
echo [%date% %time%] Detected apps: !apps! >> "%logfile%"

for %%p in (!apps!) do (
    <nul set /p="Closing %%p... "
    taskkill /f /im %%p >nul 2>&1
    echo done.
    echo [%date% %time%] Closed %%p >> "%logfile%"
)

tasklist /fi "imagename eq ms-teamsupdate.exe" | find /i "ms-teamsupdate.exe" >nul && (
    taskkill /f /im ms-teamsupdate.exe >nul 2>&1
    echo [%date% %time%] Closed ms-teamsupdate.exe >> "%logfile%"
)

echo.
<nul set /p="Waiting for Teams to close... "
:waitForTeamsClose
tasklist /fi "imagename eq ms-teams.exe" | find /i "ms-teams.exe" >nul
if %errorlevel%==0 (
    timeout /t 2 /nobreak >nul
    goto waitForTeamsClose
)
echo done.

<nul set /p="Clearing Teams cache... "
timeout /t 2 /nobreak >nul

if exist "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe"
    echo [%date% %time%] Cleared New Teams Store cache >> "%logfile%"
)

if exist "%LOCALAPPDATA%\Microsoft\MSTeams" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\MSTeams"
    echo [%date% %time%] Cleared New Teams MSI cache >> "%logfile%"
)

if exist "%APPDATA%\Microsoft\Teams" (
    rmdir /s /q "%APPDATA%\Microsoft\Teams"
    echo [%date% %time%] Cleared Classic Teams cache >> "%logfile%"
)

echo done.
echo.
echo Teams cache cleared.
echo.

echo Restarting previously closed apps...
echo [%date% %time%] Restarting apps >> "%logfile%"
for %%p in (!apps!) do (
    if /i "%%p"=="ms-teams.exe" (
        start "" ms-teams
    ) else (
        start "" %%p
    )
)

echo.
set /p restartChoice="Do you want to restart the computer? (Y/N): "

if /i "%restartChoice%"=="Y" (
    echo [%date% %time%] User requested restart ^(%restartChoice%^) >> "%logfile%"
    ::shutdown /r /t 30
    echo System will restart in 30 seconds. Save your work!
) else (
    echo [%date% %time%] Restart skipped ^(%restartChoice%^) >> "%logfile%"
)

echo.
echo Cleanup complete. Log saved to: %logfile%
pause