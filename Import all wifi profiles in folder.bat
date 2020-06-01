echo off
for %%a in ("C:\Users\kaima\OneDrive\Documents\Wifi Profiles\*.xml") do (netsh wlan add profile filename="%%a")
pause
