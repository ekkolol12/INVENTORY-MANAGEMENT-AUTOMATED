@echo off

rem Check if Python is installed
python --version 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python and run this script again.
    pause
    exit /b 1
)

cd /d %~dp0
python -m venv venv
rem Use a platform-independent activation script
call venv\Scripts\activate.bat 2>nul || venv\Scripts\activate

echo Virtual environment activated.

rem Ensure the virtual environment is activated before using pip
call :CheckVirtualEnv
if %VIRTUALENV_ACTIVATED% neq 1 (
    echo Failed to activate the virtual environment.
    pause
    exit /b 1
)

echo Installing packages...
python -m pip install -r requirements.txt
echo Packages installed.

echo Running your Python script...
python app.py

echo This window will remain open. Close it manually when you're done.

rem Exit the script
exit /b 0

:CheckVirtualEnv
rem Check if the virtual environment is activated
set VIRTUALENV_ACTIVATED=0
if "%VIRTUAL_ENV%" neq "" set VIRTUALENV_ACTIVATED=1
exit /b 0
