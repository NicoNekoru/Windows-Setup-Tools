@echo off
set DEFAULTBROWSERPATH="path\to\browser"
ftype htmlfile=%DEFAULTBROWSERPATH% %1
ftype http=%DEFAULTBROWSERPATH% %1
ftype batfile="C:\Users\%USERNAME%\AppData\Local\Microsoft\WindowsApps\wt.exe" -p "Command Prompt" "%1" %*
ftype Microsoft.PowerShellScript.1="%Systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe" "%1"
exit /b 0
