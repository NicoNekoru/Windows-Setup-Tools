@echo off
set /p i="What network profile do you want to export? "
set /p j="Where do you want to export the file? (Leave blank if you want default) "
netsh wlan export profile name="%i%" %j%