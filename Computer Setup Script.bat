@echo off

::Inspired by https://codereview.stackexchange.com/questions/224240/batch-configuration-script-for-a-new-computer

cls

:: \networkpath\*.xml is the equivalent of using netsh wlan export profile name="*" folder="\networkpath\" where \networkpath\ is the folder you want all of your profiles in.
SET NETWORKPROFILES=\networkpath\*.xml
:: Path to browsers literal .exe file
SET BROWSERPATH="PathToBrowser"
:: WT is Windows Terminal 
SET WTPATH="PathToWT.exe"

SET WINDOWS_KEY="Any Windows key"
::Find KMS keys recomended for this at https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys

SET LOGINUI_RPATH="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI"
SET SCREENSAVER_RPATH="HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop"
SET DARK_MODE_RPATH="HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
SET SPECIAL_ACCOUNT_RPATH="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
SET EXPLORER_SETTINGS_RPATH="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

call :setDefaults
call :installKey
call :configNameChange
call :disableSleep
call :clearLogin
call :explorerSettings
call :setDarkMode
call :importNetworks
call :checkDisk
@echo [INFO] Configuration Complete.

echo. && echo DEFAULT APPS && echo.
ftype Microsoft.PowerShellScript
ftype http
ftype htmlfile
ftype batfile

echo. && echo COMPUTER NAME CHANGER && echo.
type "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"

echo. && echo PERSONALIZATION REG VALUES && echo.
REG QUERY %DARKMODERPATH%

echo. && echo LOGONUI REG VALUES && echo.
REG QUERY %LOGIN_REG_PATH%

echo. && echo EXPLORER SETTINGS REG VALUES && echo.
REG QUERY %EXPLORER_SETTINGS_RPATH%

echo. && echo NETWORK PROFILES && echo.
NETSH WLAN SHOW PROFILES

echo. && echo POWERCFG VALUES && echo.
powercfg /q SCHEME_BALANCED SUB_BUTTONS LIDACTION
powercfg /q SCHEME_BALANCED SUB_SLEEP HYBRIDSLEEP

echo. && echo OS INFORMATION && echo.
systeminfo.exe | findstr /i "OS Name"

@echo *Check if any errors occured.* 
@echo Press any key to restart. && pause>Nul
shutdown /r

goto:eof 

:setDefaults
@echo Setting Default Apps
ftype htmlfile=%BRAVEPATH% %1
ftype http=%BRAVEPATH% %1
ftype batfile=%WTPATH% %1 %*
ftype Microsoft.PowerShellScript.1="%Systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe" "%1"
@echo Uninstalling OneDrive
taskkill /t /f /im OneDrive.exe && "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall 0 >Nul 2>&1 && (call  :echoPass "OneDrive Uninstalled") || (call :echoFail "Failed to uninstall OneDrive")
EXIT /B 0

:installKey
@echo [TASK] Installing Windows 10 Corporate Pro Key (%WINDOWS_KEY%)
cscript //nologo slmgr.vbs /ipk %WINDOWS_KEY% && (call  :echoPass "Windows 10 Pro Key Installed") || (call :echoFail "Failed to add Windows 10 Pro Key")
cscript //nologo slmgr.vbs /skms kms8.MSGuides.com && (call  :echoPass "Set KMS Server to kms8.msguides.com") || (call :echoFail "Failed to connect to KMS server")
cscript //nologo slmgr.vbs /ato
EXIT /B 0

:configNameChange
@echo [TASK] Configuring Automatic Name Changer
echo @echo off > "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo title Executing... >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo set /a loopcount=0 >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo :loop >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo set var=%var%%random% >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo set /a loopcount+=1 >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo if %loopcount% LEQ 7 (goto loop) >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt"
echo WMIC computersystem where caption='%COMPUTERNAME%' rename "DESKTOP-%var:~0,7%" >> "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt" 
type "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\ComputerName.txt" 0 >Nul 2>&1  && (call :echoPass "Computer Name Changer Created.")  || (call :echoFail "Computer name changer not created.")
EXIT /B 0

:disableSleep
@echo [TASK] Disabling Hybrid Sleep.
powercfg /SETACVALUEINDEX SCHEME_BALANCED SUB_SLEEP HYBRIDSLEEP 0 >Nul 2>&1  && (call :echoPass "AC hybrid sleep disabled")  || (call :echoFail "AC hybrid sleep still enabled")
powercfg /SETDCVALUEINDEX SCHEME_BALANCED SUB_SLEEP HYBRIDSLEEP 0 >Nul 2>&1  && (call :echoPass "DC hybrid sleep disabled")  || (call :echoFail "DC hybrid sleep still enabled")

@echo [TASK] Enabling Sleep LidAction
powercfg /SETDCVALUEINDEX SCHEME_BALANCED SUB_BUTTONS LIDACTION 2 >Nul 2>&1  && (call :echoPass "LidAction Sleep Enabled")  || (call :echoFail "LidAction Sleep still disabled")

@echo [TASK] Disabling Automatic Sleep
powercfg /change standby-timeout-ac 10  >Nul 2>&1  && (call :echoPass "AC sleep disabled")  || (call :echoFail "AC sleep still enabled") 
powercfg /change standby-timeout-dc 5  >Nul 2>&1  && (call :echoPass "DC sleep set to 5 minutes")  || (call :echoFail "DC sleep still enabled")

@echo [TASK] Disabling Automatic Hibernation
powercfg /hibernate off >Nul 2>&1  && (call  :echoPass "Hibernation disabled")  || (call :echoFail "Hibernation still enabled")
EXIT /B 0

:setDarkMode

@echo [TASK] Enabling Dark Mode and Other Personalizations
REG ADD %DARK_MODE_RPATH% /v "AppsUseLightTheme" /d 0 /f Nul 2>&1 && (call :echoPass "Enabled Dark Mode for apps")  || call :echoFail "Could not enable dark mode for apps")
REG ADD %DARK_MODE_RPATH% /v "SystemUsesLightTheme" /d 0 /f Nul 2>&1 && (call :echoPass "Enabled System Dark Mode")  || call :echoFail "Could not enable system dark mode")
REG ADD %DARK_MODE_RPATH% /v "EnableTransparency" /d 1 /f Nul 2>&1 && (call :echoPass "Enabled Transparency")  || call :echoFail "Could not enable transparency")
REG ADD %DARK_MODE_RPATH% /v "ColorPrevalence" /d 1 /f Nul 2>&1 && (call :echoPass "Disabled Color Prevalence")  || call :echoFail "Could not disable color prevalence")
REG ADD %DARK_MODE_RPATH% /v "NoLockScreen" /d 1 /t REG_DWORD /f Nul 2>&1 && (call :echoPass "Disabled Lock Screen")  || call :echoFail "Could not disable lock screen")
EXIT /B 0

:clearLogin
@echo [TASK] Clearing Login Screen.
REG add %LOGIN_REG_PATH% /v LastLoggedOnDisplayName /t REG_SZ /d "" /f  >Nul 2>&1 && (call :echoPass "Removed last logged on DisplayName")  || call :echoFail "Could not remove last logged on DisplayName") 
REG add %LOGIN_REG_PATH% /v LastLoggedOnSAMUser /t REG_SZ /d "" /f  >Nul 2>&1 && (call :echoPass "Removed last logged on SAMUser")  || (call :echoFail "Could not remove last logged on SAMUser") 
REG add %LOGIN_REG_PATH% /v LastLoggedOnUser /t REG_SZ /d "" /f  >Nul 2>&1  && (call :echoPass "Removed last logged on User") || (call :echoFail "Could not remove last logged on User")
::Replace <Root Password> With actual password you want for the root user
NET USERS /add Root <Root Password> >Nul 2>&1  && (call :echoPass "Added root user")|| (call :echoFail "Could not add root user")
NET LOCALGROUP ADMINISTRATORS /add Root >Nul 2>&1  && (call :echoPass "Added root user to administrators")|| (call :echoFail "Could not add root user to administrators")
REG add %SPECIAL_ACCOUNT_RPATH% /v Root /t REG_DWORD /d 0 /f >Nul 2>&1  && (call :echoPass "Set Root to special account")|| (call :echoFail "Could not set root to special account")
EXIT /B 0

:explorerSettings
@echo [TASK] Setting Explorer Settings
REG add %EXPLORER_SETTINGS_RPATH% /v ShowSuperHidden /d 1 /f >Nul 2>&1 && (call :echoPass "Enabled View of Superhidden Files")|| (call :echoFail "Did not enable view of superhidden files")
REG add %EXPLORER_SETTINGS_RPATH% /v Hidden /d 1 /f >Nul 2>&1 && (call :echoPass "Enabled View of Hidden Files")|| (call :echoFail "Did not enable view of hidden files")
REG add %EXPLORER_SETTINGS_RPATH% /v TaskbarSmallIcons /d 1 /f >Nul 2>&1 && (call :echoPass "Enabled Taskbar Small Icons")|| (call :echoFail "Did not enable taskbar small icons")
REG add %EXPLORER_SETTINGS_RPATH% /v DontUsePowershellOnWinX /d 1 /f >Nul 2>&1 && (call :echoPass "WinX Menu now shows CMD")|| (call :echoFail "WinX menu still shows powershell")
REG add %EXPLORER_SETTINGS_RPATH% /v IconsOnly /d 1 /f >Nul 2>&1 && (call :echoPass "Only Icons are Shown on the Taskbar")|| (call :echoFail "Icons are not the only thing shown on the taskbar")
REG add %EXPLORER_SETTINGS_RPATH% /v DisablePreviewDesktop /d 1 /f >Nul 2>&1 && (call :echoPass "Disabled Preview Desktop")|| (call :echoFail "Could not disable preview desktop")
REG add %EXPLORER_SETTINGS_RPATH% /v ShowStatusBar /d 1 /f >Nul 2>&1 && (call :echoPass "Showing Status Bar")|| (call :echoFail "Not showing status bar")
REG add %EXPLORER_SETTINGS_RPATH% /v TaskbarAppsVisibleInTabletMode /d 1 /f >Nul 2>&1 && (call :echoPass "Taskbar Visible in Tablet Mode")|| (call :echoFail "Taskbar not visible in tablet mode")
REG add %EXPLORER_SETTINGS_RPATH% /v HideFileExt /d 0 /f >Nul 2>&1 && (call :echoPass "Not Hiding File Extensions")|| (call :echoFail "File extensions are hidden")
EXIT /B 0

:importNetworks

@echo [TASK] Importing Network Profiles.
for %%a in (%NETWORKPROFILES%) do (netsh wlan add profile filename="%%a") >Nul 2>&1  && (call :echoPass "Wi-Fi profiles imported")  || (call :echoFail "Wi-Fi profiles not imported") 
EXIT /B 0

:checkDisk
@echo [TASK] Checking disk for errors...
sfc /SCANNOW
chkdsk C: /F /V /SCAN /R /X /SDCCLEANUP /B /SPOTFIX
EXIT /B 0

:printFail
call :printInfo
echo |set /p="[ERROR] "
EXIT /B 0

:printPass
call :printInfo
echo |set /p="[SUCCESS] "
EXIT /B 0

:printInfo
echo|set /p="[INFO] "
EXIT /B 0

:echoFail
call :printFail
echo %~1
EXIT /B 0

:echoPass
call :printPass
echo %~1
EXIT /B 0
