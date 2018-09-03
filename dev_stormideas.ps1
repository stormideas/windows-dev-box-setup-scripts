# Description: Boxstarter Script
# Author: Microsoft
# Common settings for web dev

Disable-UAC

function executeScript {
    Param ([string]$script)
    write-host "executing $finalBaseHelperUri/$script ..."
    iex ((new-object net.webclient).DownloadString("$finalBaseHelperUri/$script"))
}

# see if we can't get calling URL somehow, that would eliminate this need
# should move to a config file
$user = "stormideas";
$baseBranch = "master";
$finalBaseHelperUri = "https://raw.githubusercontent.com/$user/windows-dev-box-setup-scripts/$baseBranch/scripts";

#--- Configuring Windows properties ---
#--- Windows Features ---
# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#taskbar where window is open for multi-monitor
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2
#turn off checkboxes in explorer
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -Value 0

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

# tools we expect devs across many scenarios will want
choco install -y vscode
choco install -y git -params '"/GitAndUnixToolsOnPath /WindowsTerminal"'
choco install -y python
choco install -y 7zip.install
choco install -y nodejs-lts
choco install -y yarn

executeScript "RemoveDefaultApps.ps1";

# Virtualization
choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures
choco install -y Microsoft-Hyper-V-All -source windowsFeatures
choco install -y docker-for-windows
choco install -y vscode-docker

# SQL
choco install sql-server-management-studio

# Web Front End
npm install -g @angular/cli

#--- Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

#--- Browsers ---
choco install -y firefox

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula