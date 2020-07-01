echo off
for %%a in ("Wifi Profiles\*.xml") do (netsh wlan add profile filename="%%a")
pause
