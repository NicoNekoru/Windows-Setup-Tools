@echo off
SET EXPLORER_SETTINGS_RPATH="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
REG add %EXPLORER_SETTINGS_RPATH% /v ShowSuperHidden /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v Hidden /d 1 /f 
REG add %EXPLORER_SETTINGS_RPATH% /v TaskbarSmallIcons /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v DontUsePowershellOnWinX /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v IconsOnly /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v DisablePreviewDesktop /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v ShowStatusBar /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v TaskbarAppsVisibleInTabletMode /d 1 /f
REG add %EXPLORER_SETTINGS_RPATH% /v HideFileExt /d 0 /f
EXIT /B 0
