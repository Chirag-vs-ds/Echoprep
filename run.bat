@echo off
setlocal

:: ---------------------------------------------------------------
:: Interview Copilot - launcher
:: Double-click this file to run the app.
:: On first run: creates a venv and installs dependencies.
:: ---------------------------------------------------------------

set "ROOT=%~dp0interview-copilot"
set "VENV=%~dp0venv"
set "PYTHON=python"

:: Check LLM_API_KEY
if "%LLM_API_KEY%"=="" goto no_key

:: Create venv if it does not exist
if not exist "%VENV%\Scripts\pythonw.exe" goto create_venv

:: Verify dependencies are installed (handles partial/interrupted venv)
"%VENV%\Scripts\python.exe" -c "import numpy, pyaudiowpatch, faster_whisper, openai, keyboard, websocket" 2>nul
if errorlevel 1 goto install_deps
goto launch

:create_venv
echo [run.bat] Creating virtual environment...
%PYTHON% -m venv "%VENV%"
if errorlevel 1 goto venv_err

:install_deps
echo [run.bat] Installing dependencies - first run, may take a minute...
"%VENV%\Scripts\pip.exe" install -r "%ROOT%\requirements.txt"
if errorlevel 1 goto pip_err
echo [run.bat] Setup complete.

:launch
echo [run.bat] Starting Interview Copilot...
start "" "%VENV%\Scripts\pythonw.exe" "%ROOT%\app.py"
exit /b 0

:no_key
echo.
echo  *** LLM_API_KEY is not set ***
echo.
echo  You need a free API key to use the LLM.
echo.
echo  Option A - Groq   [fast, free]: https://console.groq.com
echo  Option B - Gemini [free]:       https://aistudio.google.com/apikey
echo.
echo  After getting your key, run this in a NEW terminal:
echo     setx LLM_API_KEY "your_key_here"
echo  Then close that terminal and double-click run.bat again.
echo.
pause
exit /b 1

:venv_err
echo ERROR: Could not create venv. Is Python installed?
echo Download Python 3.10+ from https://www.python.org/downloads/
pause
exit /b 1

:pip_err
echo ERROR: pip install failed. Check your internet connection.
pause
exit /b 1
