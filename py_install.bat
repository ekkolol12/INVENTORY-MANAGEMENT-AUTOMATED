@echo off
:: Check for administrative privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If the script is not run as Administrator, relaunch it with elevated permissions
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto :start
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\RunElevated.vbs"
echo UAC.ShellExecute "cmd.exe", "/c ""%~0""", "", "runas", 1 >> "%temp%\RunElevated.vbs"

:: Run the VBScript to prompt for elevation
"%temp%\RunElevated.vbs"
del "%temp%\RunElevated.vbs"
exit /B

:start
set "python_version=3.12.1"
set "install_dir=C:\Python\%python_version%"

echo Checking if Python is already installed...

:: Check if Python is already installed
python --version 2>NUL
if %errorlevel% equ 0 (
    echo Python is already installed. Exiting.
    pause
    exit /b 0
)

echo Installing Python %python_version%...

:: Download Python installer
curl -o python_installer.exe https://www.python.org/ftp/python/%python_version%/python-%python_version%-amd64.exe

:: Install Python with additional features
start /wait python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir="%install_dir%" DefaultAllUsersTargetDir="%install_dir%" Include_launcher=1 InstallLauncherAllUsers=1 Include_doc=1 Include_tcltk=1 Include_dev=1 Include_pip=1 Include_debug=0

:: Disable path length limit
setx PATH "%PATH%;" -m

:: Cleanup
del python_installer.exe

echo Python %python_version% has been installed to %install_dir%

:: Pause and wait for user input before closing
pause
