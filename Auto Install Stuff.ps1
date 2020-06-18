$uri = 'https://laptop-updates.brave.com/latest/winx64'
$outFile = "$Home\Desktop\BraveBrowserSetup.exe"
#Installing Brave Browser
#Change $uri to whatever the installation website is and $outfile to where you want the download location to be.
if ($PSVersionTable.PSVersion.Major -lt 3) {
    (New-Object -TypeName System.Net.WebClient).DownloadFile($uri, $outFile)
}
else {
    Invoke-WebRequest -Uri $uri -OutFile $outFile
}
& $outFile /silent /install

#Installing PS Core 7.1
#Same deal, change $Uri2 and $outFile2 to whatever you want
$uri2 = https://github.com/PowerShell/PowerShell/releases/download/v7.1.0-preview.3/PowerShell-7.1.0-preview.3-win-x64.msi
$outFile2 = "$Home\Desktop\PowerShell-7.0.1-win-x64.msi"

if ($PSVersionTable.PSVersion.Major -lt 3) {
    (New-Object -TypeName System.Net.WebClient).DownloadFile($uri, $outFile)
}
else {
    Invoke-WebRequest -Uri $uri2 -OutFile $outFile2
}
msiexec.exe /package PowerShell-7.0.1-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1
