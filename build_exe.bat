@echo off
setlocal

:: ---------------------------------------------------------------
:: Interview Copilot - PyInstaller build script
:: Produces a windowed one-folder exe at dist\InterviewCopilot\
:: Run from the outer interview-copilot\ directory.
:: ---------------------------------------------------------------

set "ROOT=%~dp0interview-copilot"
set "VENV=%~dp0venv"
set "DIST=%~dp0dist"

:: Prefer the project venv if present
if exist "%VENV%\Scripts\python.exe" (
    set "PY=%VENV%\Scripts\python.exe"
    set "PIP=%VENV%\Scripts\pip.exe"
) else (
    set "PY=python"
    set "PIP=pip"
)

:: Install / upgrade PyInstaller inside the venv
echo [build] Installing/upgrading PyInstaller...
"%PIP%" install --upgrade pyinstaller --quiet
if errorlevel 1 (
    echo ERROR: Could not install PyInstaller.
    pause
    exit /b 1
)

echo [build] Running PyInstaller...
"%PY%" -m PyInstaller ^
    --noconfirm ^
    --windowed ^
    --name InterviewCopilot ^
    --distpath "%DIST%" ^
    --workpath "%~dp0build" ^
    --specpath "%~dp0" ^
    --collect-all faster_whisper ^
    --collect-all ctranslate2 ^
    --collect-all pyaudiowpatch ^
    --hidden-import tkinter ^
    --hidden-import pypdf ^
    --hidden-import docx ^
    --add-data "%ROOT%\config.py;." ^
    --add-data "%ROOT%\settings.py;." ^
    --add-data "%ROOT%\stt_deepgram.py;." ^
    --add-data "%ROOT%\audio.py;." ^
    --add-data "%ROOT%\llm.py;." ^
    --add-data "%ROOT%\resume.py;." ^
    "%ROOT%\app.py"

if errorlevel 1 (
    echo.
    echo ERROR: PyInstaller build failed. See output above.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Build complete!
echo  Executable folder: %DIST%\InterviewCopilot\
echo  Run: %DIST%\InterviewCopilot\InterviewCopilot.exe
echo ============================================================
echo.
pause
endlocal

