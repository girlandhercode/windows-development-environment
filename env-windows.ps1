#-------------------------------------------------------------------------------#
#                                                                               #
#                                                                               #
# Run PowerShell with admin priveleges, type `env-windows`                      #
#                                                                               #
#                                                                               #
#                                                                               #
#-------------------------------------------------------------------------------#

#
# Functions
#

function RefreshEnvPath
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") `
        + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# set the timezone.
# tzutil /l lists all available timezone ids
#      Explaination of ampersand at beginning:
#      "the solution is to use the Invoke Operator "&", which is used to run script blocks
#      PS C:\> & 'c:\new folder\myscript.ps1' param1
#      From: http://blog.heshamamin.com/2009/04/calling-powershell-script-in-path-with.html

& $env:windir\system32\tzutil /s "Eastern Standard Time"


#
# Package Managers
#

# Choco
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | iex
RefreshEnvPath



choco install chocolatey-core.extension
RefreshEnvPath



# From: https://community.spiceworks.com/scripts/show/3298-windows-10-decrapifier-version-1
#Latest version, April 7, 2017

# Write-Host "*******   Removing Pre-Installed Applications - Windows 10...   *******"
# Write-Host "***   Removing App Packages...   ***"

#I recommend running this script on a fresh install, though it should work fine anyways.  Should ;)
#This part removes all the apps.  By default, it removes everything except the calculator, photos, sound recorder, and the store.  To remove all apps including the store, comment out this part...

# Get-AppxPackage -AllUsers | where-object {$_.name -notlike "*Store*" -and $_.name -notlike "*Calculator*" -and $_.name -notlike "*Windows.Photos*" -and $_.name -notlike "*SoundRecorder*"} | Remove-AppxPackage -erroraction silentlycontinue
# Get-AppxPackage -AllUsers | where-object {$_.name -notlike "*Store*" -and $_.name -notlike "*Calculator*" -and $_.name -notlike "*Windows.Photos*" -and $_.name -notlike "*SoundRecorder*"} | Remove-AppxPackage -erroraction silentlycontinue
#
# Get-AppxProvisionedPackage -online | where-object {$_.displayname -notlike "*Store*" -and $_.displayname -notlike "*Calculator*" -and $_.displayname -notlike "*Windows.Photos*" -and $_.displayname -notlike "*SoundRecorder*"} | Remove-AppxProvisionedPackage -online -erroraction silentlycontinue



#... and comment in this one:

#Get-AppxPackage -AllUsers | Remove-AppxPackage -erroraction silentlycontinue
#Get-AppxPackage -AllUsers | Remove-AppxPackage -erroraction silentlycontinue

#Get-AppXProvisionedPackage -Online | Remove-AppxProvisionedPackage -online -erroraction silentlycontinue


#Now apps are removed, below we will disable a bunch of features.  The rabbit hole is deep, this are the ones I thought most important.

Write-Host "***   Disabling delivery optimization for local machine...   ***"

Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /T REG_DWORD /V "DODownloadMode" /D 0 /F
Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /V "DownloadMode" /T REG_DWORD /D 0 /F
Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /V "DODownloadMode" /T REG_DWORD /D 0 /F

Write-Host "***   Changing delivery optimization download mode for this user...   *** "

Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /T REG_DWORD /V "SystemSettingsDownloadMode" /D 3 /F

#This part disables auto-update and auto-download of Store apps for all users. Set value to 2=always off, 4=always on

Write-Host "***Disabling auto update and download of Windows Store Apps...***"

Reg Add "HKCU\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "AutoDownload" /D 2 /F

#Next Section is for Anniversary Edition, comment it in if you are on 1607+, no effect it seems on previous editions

Write-Host "***   Disabling Suggested Apps, Feedback, Lockscreen Spotlight, File Explorer ads (WTF??? seriously M$!!!), and unwanted app installs for this user...   ***"

Reg Add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "SystemPaneSuggestionsEnabled" /D 0 /F
Reg Add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "SoftLandingEnabled" /D 0 /F
Reg Add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "RotatingLockScreenEnable" /D 0 /F
Reg Add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "PreInstalledAppsEnabled" /D 0 /F
Reg Add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "SilentInstalledAppsEnabled" /D 0 /F
Reg Add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "ContentDeliveryAllowed" /D 0 /F
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /T REG_DWORD /V "ShowSyncProviderNotifications" /D 0 /F

#1607+ Features end

# Write-Host "***Disabling Cloud-Content for this machine...***"
# Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent\" /T REG_DWORD /V "DisableWindowsConsumerFeatures" /D 1 /F
#
# Write-Host "***Disabling OneDrive for local machine...***"
#
# Reg Add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSyncNGSC" /D 1 /F
# Reg Add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSync" /D 1 /F
#
# Write-Host "***Disabling Onedrive startup run for this user...***"
#
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /T REG_BINARY /V "OneDrive" /D 0300000021B9DEB396D7D001 /F

Write-Host "***   Disabling telemetry for local machine...   ***"

Reg Add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "AllowTelemetry" /D 0 /F
Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /V "PreventDeviceMetadataFromNetwork" /T REG_DWORD /D 1 /F
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /V "DontOfferThroughWUAU" /T REG_DWORD /D 1 /F
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /V "CEIPEnable" /T REG_DWORD /D 0 /F
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /V "AITEnable" /T REG_DWORD /D 0 /F
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /V "DisableUAR" /T REG_DWORD /D 1 /F

Write-Host "***   Setting Windows 10 privacy options for this user...   ***"

Reg Add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessAccountInfo" /D 2 /F
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /T REG_DWORD /V "EnableWebContentEvaluation" /D 0 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /T REG_DWORD /V "Enabled" /D 0  /F
# Reg Add "HKCU\Control Panel\International\User Profile" /T REG_DWORD /V "HttpAcceptLanguageOptOut" /D 1 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /T REG_SZ /V Value /D DENY /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /T REG_DWORD /V "AcceptedPrivacyPolicy" /D 0 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /T REG_DWORD /V "Enabled" /D 0 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitTextCollection" /D 1 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitInkCollection" /D 1 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /T REG_DWORD /V "HarvestContacts" /D 0 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "NumberOfSIUFInPeriod" /D 0 /F


Write-Host "***   Disallowing apps from accessing account info on this machine...   ***"

Reg Add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessAccountInfo" /D 2 /F

Write-Host "***   Disallowing Cortana and web connected search through local machine policy...   ***"

# Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V "AllowCortana" /T REG_DWORD /D 0 /F
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V "ConnectedSearchUseWeb" /T REG_DWORD /D 0 /F

Write-Host "***   Disabling Cortana and Bing search for this user...   ***"

Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "CortanaEnabled" /T REG_DWORD /D 0 /F
# Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "SearchboxTaskbarMode" /T REG_DWORD /D 0 /F
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "BingSearchEnabled" /T REG_DWORD /D 0 /F
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "DeviceHistoryEnabled" /T REG_DWORD /D 0 /F

# Write-Host "***   Disabling some unecessary scheduled tasks...   ***"

# Get-Scheduledtask "SmartScreenSpecific","Microsoft Compatibility Appraiser","Consolidator","KernelCeipTask","UsbCeip","Microsoft-Windows-DiskDiagnosticDataCollector", "GatherNetworkInfo","QueueReporting" | Disable-scheduledtask

# Write-Host "***   Stopping and disabling diagnostics tracking services, Onedrive sync service, various Xbox services, Distributed Link Tracking, and Windows Media Player network sharing (you can turn this back on if you share your media libraries with WMP)...   ***"

# Get-Service Diagtrack,DmwApPushService,OneSyncSvc,XblAuthManager,XblGameSave,XboxNetApiSvc,TrkWks,WMPNetworkSvc | stop-service -passthru | set-service -startuptype disabled

Write-Host "*******   Operations complete.   *******"

Write-Host "If you have unremovable tiles on your start menu afterwards, copy c:\users\USER\appdata\local\tiledatalayer from a fresh profile, AFTER running the script, to your profile, overwriting what is there. The main file is tiledatelayer.edb. This will give you a default start menu but without all the useless app icons."
Write-Host "This doesn't seem to be an issues with 1511 +"


Write-Host "*******   Remove/Prevent non-provisioned apps installed by the store   *******"

# Disable Suggested Apps In Windows Start Bar
# From: https://github.com/engrmtm/INT_Experimental
$CloudRegistry = "HKLM:\Software\Policies\Microsoft\Windows\CloudContent"
New-ItemProperty -Path $CloudRegistry -Name DisableWindowsConsumerFeatures -Value 1 -PropertyType DWORD -Force | Out-Null
#
# Git
#

choco install git --yes --params '/GitAndUnixToolsOnPath'
# choco install tortoisegit --yes
RefreshEnvPath

#
# Languages
#

# choco install php --yes
choco install python2 --yes
RefreshEnvPath

# Node
choco install nodejs.install --yes
RefreshEnvPath
npm install --global npm-windows-upgrade
npm-windows-upgrade --npm-version latest
npm install -g gulp-cli
# npm install -g yo
# npm install -g mocha
# npm install -g install-peerdeps
# npm install -g typescript
# npm install prettier-eslint --save-dev

#
# Docker
#
# choco install docker --yes
# choco install docker-machine --yes
# choco install docker-compose --yes
# RefreshEnvPath
# docker pull worpress
# docker pull mysql
# docker pull phpmyadmin



# Bower
# npm install -g bower

# Grunt
# npm install -g grunt-cli

# ESLint
# npm install -g eslint
# npm install -g babel-eslint
# npm install -g eslint-plugin-react
# npm install -g install-peerdeps
# install-peerdeps --dev eslint-config-airbnb

#
# VS Code
#

choco install visualstudiocode --yes # includes dotnet
RefreshEnvPath
# # code --install-extension robertohuertasm.vscode-icons
code --install-extension Shan.code-settings-sync


choco install atom --version 1.24.0-beta1 --yes
RefreshEnvPath

#
# Basic Utilities
#
choco install wget --yes
choco install windirstat --yes
choco install sumatrapdf.install --yes
choco install peazip.install --yes
choco install irfanview --params '/assoc=1' --yes
choco install everything --params '/quick-launch-shortcut /run-on-system-startup /service' --yes
choco install imgburn --yes
choco install evernote --yes
choco install conemu --yes
choco install f.lux --yes
choco install plexmediaserver --yes
choco install paint.net --yes
choco install vlc --yes
choco install qbittorrent --yes

RefreshEnvPath


# choco install xenulinksleuth --yes

# File Management
# #choco install beyondcompare --yes
choco install dropbox --yes

# Browsers
choco install googlechrome --yes
# #choco install firefox --yes


RefreshEnvPath

$destination = $env:USERPROFILE

# Download these files UNLESS the most current version exists in the defined location ('-N')
# $destination is set to the environment variable for '<windows drive letter>:/Users/<current user's name>'
# for example: 'C:/Users/Vector' ('-P')
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Bold.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Medium.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Regular.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Text.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-SemiBold.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Italic.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-MediumItalic.ttf
wget.exe -N -P $destination/Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-SemiBoldItalic.ttf
wget.exe -N -P $destination/Fonts https://github.com/sgolovine/PlexNerdfont/blob/master/Text/IBM%20Plex%20Mono%20Text%20Nerd%20Font%20Complete%20Mono.otf
wget.exe -N -P $destination/Fonts https://github.com/sgolovine/PlexNerdfont/blob/master/Regular/IBM%20Plex%20Mono%20Nerd%20Font%20Complete%20Mono.otf
wget.exe -N -P $destination/Fonts https://github.com/sgolovine/PlexNerdfont/blob/master/Medium/IBM%20Plex%20Mono%20Medium%20Nerd%20Font%20Complete%20Mono.otf
wget.exe -N -P $destination/Fonts https://www.fontsquirrel.com/fonts/download/archivo-narrow.zip
wget.exe -N -O "$destination/Downloads/Firefox_Quantum_Setup.exe" "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=win64&lang=en-US"
wget.exe -N -O "$destination/Downloads/Battle_Net.exe" "https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP"
wget.exe -N -O "$destination/Downloads/Razer_Synapse.exe" "http://rzr.to/synapse-pc-download"
wget.exe -N -O "$destination/Downloads/DiscordSetup.exe" "https://discordapp.com/api/download?platform=win"



#########################################################
# Remove Windows 10 Modern Apps (System)
# From: https://github.com/DigitalWhitewater/Powershell
#########################################################

# To find app names use:
# Get-AppxProvisionedPackage -online  | Select DisplayName, PackageName


$appxpackages = (
	'3DBuilder',
	'BingFinance',
	'BingSports',
	'CommsPhone',
	'ConnectivityStore',
	'GetHelp',
	'Getstarted',
	'HaloCamera',
	'HaloItemPlayerApp',
	'HaloShell',
	'Messaging',
	'Microsoft3DViewer',
	'MicrosoftOfficeHub',
	'MicrosoftSolitaireCollection',
	'Office.Sway',
	'OneConnect',
	'OneNote',
	'People',
	'Print3D',
	'SkypeApp',
	'WindowsFeedbackHub',
	'WindowsPhone',
	'Xbox.TCUI',
	'XboxApp',
	'ZuneMusic',
	'ZuneVideo',
	'windowscommunicationsapps',
  'FarmVille2CountryEscape',
  'PandoraMediaInc',
  'Microsoft.SkypeApp',
  'Facebook',
  'DrawboardPDF',
  'Twitter',
  'XboxOneSmartGlass',
  'Asphalt8Airborne',
  'BingWeather'
)

ForEach($package in $appxpackages)
{
    try{
	    $packagenames=(Get-AppxProvisionedPackage -online | ?{$_.DisplayName -like '*' + $package + '*'}).PackageName

	    ForEach ($packagename in $packagenames)
	    {
		    DISM /online /remove-provisionedappxpackage /packagename:$packagename
	    }
    }
    catch
    {
	    # Do nothing
	    Write-Host "Critical error removing package: "
	    Write-Host $package
    }
}

Get-AppxPackage -allusers *Getstarted* | Remove-AppxPackage
Get-AppxPackage -allusers *MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage -allusers *Micorsoft3DViewer* | Remove-AppxPackage
Get-AppxPackage -allusers *Xbox.TCUI* | Remove-AppxPackage
Get-AppxPackage -allusers *XboxSpeechToTextOverlay* | Remove-AppxPackage
Get-AppxPackage -allusers *XboxApp* | Remove-AppxPackage
Get-AppxPackage -allusers *BingWeather* | Remove-AppxPackage
Get-AppxPackage -allusers *ZuneMusic* | Remove-AppxPackage
Get-AppxPackage -allusers *ZuneVideo* | Remove-AppxPackage
Get-AppxPackage -allusers *MicrosoftSolitairCollection* | Remove-AppxPackage
Get-AppxPackage -allusers *SkypeApp* | Remove-AppxPackage
Get-AppxPackage -allusers *Office.OneNote* | Remove-AppxPackage
Get-AppxPackage -allusers *Asphalt8Airborne* | Remove-AppxPackage
Get-AppxPackage -allusers *CandyCrushSodaSaga* | Remove-AppxPackage
Get-AppxPackage -allusers *DrawboardPDF* | Remove-AppxPackage
Get-AppxPackage -allusers *Facebook* | Remove-AppxPackage
Get-AppxPackage -allusers *FarmVille2CountryEscape* | Remove-AppxPackage
Get-AppxPackage -allusers *WindowsFeedBackHub* | Remove-AppxPackage
Get-AppxPackage -allusers *officehub* | Remove-AppxPackage
Get-AppxPackage -allusers *Microsoft.SkypeApp* | Remove-AppxPackage
Get-AppxPackage -allusers *Messaging* | Remove-AppxPackage
Get-AppxPackage -allusers *OneNote* | Remove-AppxPackage
Get-AppxPackage -allusers *PandoraMediaInc* | Remove-AppxPackage
Get-AppxPackage -allusers *MSPaint* | Remove-AppxPackage
Get-AppxPackage -allusers *Office.Sway* | Remove-AppxPackage
Get-AppxPackage -allusers *Twitter* | Remove-AppxPackage
Get-AppxPackage -allusers *XboxOneSmartGlass* | Remove-AppxPackage



#################################################################
# From: https://github.com/rgl/windows-domain-controller-vagrant
#################################################################

# show window content while dragging.
Set-ItemProperty -Path 'HKCU:Control Panel\Desktop' -Name DragFullWindows -Value 1

# show hidden files.
Set-ItemProperty -Path HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1

# show protected operating system files.
Set-ItemProperty -Path HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSuperHidden -Value 1

# show file extensions.
Set-ItemProperty -Path HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0

# hide the search button.
Set-ItemProperty -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0

# never combine the taskbar buttons.
# possibe values:
#   0: always combine and hide labels (default)
#   1: combine when taskbar is full
#   2: never combine
Set-ItemProperty -Path HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarGlomLevel -Value 2

# Taskbar: use small icons (0: Large Icons, 1: Small Icons)
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

# SysTray: hide the Action Center, Network, and Volume icons
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAHealth" 1

# display full path in the title bar.
New-Item -Path HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState -Force `
    | New-ItemProperty -Name FullPath -Value 1 -PropertyType DWORD `
    | Out-Null

# From: https://github.com/JourneyOver/AutoBox
# Turn on always show all icons in the notification area
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "EnableAutoTray" 0

# Sound: Disable Startup Sound
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1

# Start Menu: Disable Highlight Newly Installed Applications
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_NotifyNewApps" 0


###########################################################################
# Function to set registry values and create them if they do not exist:
# From: https://github.com/chuckbales/powershell
###########################################################################

# function Set-Reg {
#     param (
#         [string]$key,
#         [string]$name,
#         [string]$value,
#         [string]$type
#     )
#
#     If((Test-Path -Path $key) -eq $false) {
#         New-Item -Path $key
#     }
#     $k = Get-Item -Path $key
#     If($k.GetValue($name) -eq $null) {
#         New-ItemProperty -Path $key -Name $name -Value $value -PropertyType $type
#     } else {
#         Set-ItemProperty -Path $key -Name $name -Value $value
#     }
# }

# Set execution policy
# Set-ExecutionPolicy unrestricted -Force

#Set Windows Explorer settings
# $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\'
# Set-Reg -key $key -name 'HideFileExt' -value 0 -type 'DWord'
# Set-Reg -key $key -name 'NavPaneShowAllFolders' -value 1 -type 'DWord'
# Set-Reg -key $key -name 'NavPaneExpandToCurrentFolder' -value 1 -type 'DWord'
# Set-Reg -key $key -name 'Start_NotifyNewApps' -value 0 -type 'DWord'
# Set-Reg -key $key -name 'Start_ShowMyComputer' -value 2 -type 'DWord'
# Set-Reg -key $key -name 'Start_ShowControlPanel' -value 2 -type 'DWord'
# Set-Reg -key $key -name 'Start_ShowRun' -value 1 -type 'DWord'
# Set-Reg -key $key -name 'StartMenuAdminTools' -value 2 -type 'DWord'
# Set-Reg -key $key -name 'TaskbarSmallIcons' -value 1 -type 'DWord'
# Set-Reg -key $key -name 'TaskbarGlomLevel' -value 2 -type 'DWord'





#######################################################################
# Also from: https://github.com/chuckbales/powershell
#######################################################################

#Disable Sticky keys prompt
Write-Host "Disabling Sticky keys prompt..."
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

#######################################################################
# From: https://github.com/brennanfee/provision-windows
#######################################################################
# To query installed features:  Get-WindowsOptionalFeature -Online | where {$_.State -eq "Enabled"} | select FeatureName
# Install WSL
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -NoRestart



RefreshEnvPath


Stop-Process -ProcessName explorer

Start-Sleep -s 10

Write-Host "Remaining Pre-Installed MS Packages:"
Get-AppxPackage | Select Name, PackageFullName

# Start-Sleep -s 30
# Get-AppxPackage | Select Name, PackageFullName | Measure-Object

Start-Sleep -s 10

&".\test-mod-app-removal.ps1"

# Write-Output "Finished! Run `choco upgrade all` to get the latest software"
# Write-Output "*******  Reboot  *******"
