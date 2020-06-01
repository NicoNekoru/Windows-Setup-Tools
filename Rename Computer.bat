@echo off
title Executing...
set /a loopcount=0
:loop
set var=%var%%random%
set /a loopcount+=1
if %loopcount% LEQ 7 (goto loop)
WMIC computersystem where caption='%COMPUTERNAME%' rename "DESKTOP-%var:~0,7%"
shutdown /r