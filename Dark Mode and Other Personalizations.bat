@echo off
SET RPATH="HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
REG ADD %RPATH% /v "AppsUseLightTheme" /d 0 /f Nul 2>&1 && (call :echoPass "Enabled Dark Mode for apps")  || call :echoFail "Could not enable dark mode for apps")
REG ADD %RPATH% /v "SystemUsesLightTheme" /d 0 /f Nul 2>&1 && (call :echoPass "Enabled System Dark Mode")  || call :echoFail "Could not enable system dark mode")
REG ADD %RPATH% /v "EnableTransparency" /d 1 /f Nul 2>&1 && (call :echoPass "Enabled Transparency")  || call :echoFail "Could not enable transparency")
REG ADD %RPATH% /v "ColorPrevalence" /d 1 /f Nul 2>&1 && (call :echoPass "Disabled Color Prevalence")  || call :echoFail "Could not disable color prevalence")
REG ADD %RPATH% /v "NoLockScreen" /d 1 /t REG_DWORD /f Nul 2>&1 && (call :echoPass "Disabled Lock Screen")  || call :echoFail "Could not disable lock screen")
EXIT /B 0
