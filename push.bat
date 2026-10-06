@echo off
rem ============================================================
rem  AI qianming gift - one click push
rem  Usage:
rem    double click          -> ask for commit message, then push
rem    push.bat "your msg"   -> commit with message, then push
rem  NOTE: this file must stay pure ASCII. No Chinese characters.
rem ============================================================
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ==========================================
echo   Git Push Helper
echo ==========================================
echo.

rem ---- 1. check git ----
where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] git is not installed or not in PATH.
  echo         Install Git for Windows: https://git-scm.com/
  echo.
  pause
  exit /b 1
)

rem ---- 2. check we are inside a repo ----
git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Current folder is NOT a git repository: %CD%
  echo.
  pause
  exit /b 1
)

rem ---- 3. check remote ----
set "HAS_REMOTE="
for /f "delims=" %%i in ('git remote 2^>nul') do set "HAS_REMOTE=%%i"
if not defined HAS_REMOTE (
  echo [ERROR] No remote configured for this repository.
  echo         Add one first, for example:
  echo           git remote add origin https://github.com/USER/REPO.git
  echo.
  pause
  exit /b 1
)

rem ---- 4. current branch ----
set "BRANCH="
for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "BRANCH=%%i"
if not defined BRANCH set "BRANCH=master"

echo Folder : %CD%
echo Remote  : %HAS_REMOTE%
echo Branch  : %BRANCH%
echo.

rem ---- 5. show changes ----
echo ---- Changes to be committed ----
git status --short
echo ---------------------------------
echo.

rem ---- 6. commit message ----
set "MSG=%~1"
if not defined MSG (
  set /p "MSG=Commit message (press Enter to skip commit): "
)

rem ---- 7. stage ----
git add -A
if errorlevel 1 (
  echo.
  echo [ERROR] git add failed.
  pause
  exit /b 1
)

rem ---- 8. commit only if there is something staged ----
git diff --cached --quiet
if errorlevel 1 (
  if not defined MSG (
    echo.
    echo [ERROR] Files are staged but no commit message was given.
    echo         Nothing was committed. Nothing was pushed.
    echo.
    pause
    exit /b 1
  )
  git commit -m "%MSG%"
  if errorlevel 1 (
    echo.
    echo [ERROR] git commit failed.
    pause
    exit /b 1
  )
) else (
  echo No staged changes, skipping commit.
)

rem ---- 9. push ----
echo.
echo ---- Pushing to %HAS_REMOTE% / %BRANCH% ----
git push -u origin %BRANCH%
if errorlevel 1 (
  echo.
  echo [ERROR] git push failed.
  echo.
  echo How to tell network from auth problem:
  echo   git ls-remote origin
  echo     - if THAT also fails  = network issue, check proxy or VPN
  echo     - if that works       = auth issue, check credential or SSH key
  echo.
  echo If the remote has newer commits, run first:
  echo   git pull --rebase origin %BRANCH%
  echo.
  pause
  exit /b 1
)

rem ---- 10. done ----
echo.
echo [OK] Pushed successfully.
echo.
git log --oneline -3
echo.
pause
