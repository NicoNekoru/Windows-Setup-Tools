@echo off
echo Activating your Windows...
cscript //nologo slmgr.vbs /upk >nul & cscript //nologo slmgr.vbs /cpky >nul
cscript //nologo slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43 >nul && call :server
cscript //nologo slmgr.vbs /ipk DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4 >nul && call :server
cscript //nologo slmgr.vbs /ipk WNMTR-4C88C-JK8YV-HQ7T2-76DF9 >nul && call :server
cscript //nologo slmgr.vbs /ipk 2F77B-TNFGY-69QQF-B8YKP-D69TJ >nul && call :server
cscript //nologo slmgr.vbs /ipk DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ >nul && call :server
cscript //nologo slmgr.vbs /ipk QFFDN-GRT3P-VKWWX-X7T3R-8B639 >nul && call :server
cscript //nologo slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul && call :server
cscript //nologo slmgr.vbs /ipk MH37W-N47XK-V7XM9-C7227-GCQG9 >nul && call :server
cscript //nologo slmgr.vbs /ipk NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J >nul && call :server
cscript //nologo slmgr.vbs /ipk 9FNHH-K3HBT-3W4TD-6383H-6XYWF >nul && call :server
cscript //nologo slmgr.vbs /ipk 6TP4R-GNPTD-KYYHQ-7B7DP-J447Y >nul && call :server
cscript //nologo slmgr.vbs /ipk YVWGF-BXNMC-HTQYQ-CPQ99-66QFC >nul && call :server
cscript //nologo slmgr.vbs /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99 >nul && call :server
cscript //nologo slmgr.vbs /ipk 3KHY7-WNT83-DGQKR-F7HPR-844BM >nul && call :server
cscript //nologo slmgr.vbs /ipk 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH >nul && call :server
cscript //nologo slmgr.vbs /ipk PVMJN-6DFY6-9CCP6-7BKTT-D3WVR >nul && call :server
set i=1
:server
if %i%==1 set KMS_Sev=kms8.MSGuides.com
if %i%==2 set KMS_Sev=kms7.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto end
cscript //nologo slmgr.vbs /skms %KMS_Sev% || set i=%i%+1 && goto server
cscript //nologo slmgr.vbs /ato || set i=%i%+1 && goto server
winver
pause
exit /b 0
:end
exit /b 0