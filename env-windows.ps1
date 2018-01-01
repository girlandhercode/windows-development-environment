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

#
# Package Managers
#

# Choco
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | iex
RefreshEnvPath



choco install chocolatey-core.extension
RefreshEnvPath

#
# Git
#

choco install git --yes --params '/GitAndUnixToolsOnPath'
# choco install tortoisegit --yes
RefreshEnvPath


# wontdo: Alias `make` to `mingw32-make` in Git Bash
# wontdo: Write `mingw32-make %*` to make.bat in MinGW install directory


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
npm install -g yo
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
# code --install-extension robertohuertasm.vscode-icons
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

RefreshEnvPath


# choco install xenulinksleuth --yes

# File Management
#choco install beyondcompare --yes
choco install dropbox --yes

# Media Viewers
choco install irfanview --yes
choco install vlc --yes

# Browsers
choco install googlechrome --yes
#choco install firefox --yes


RefreshEnvPath

wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Bold.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Medium.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Regular.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Text.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-SemiBold.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-Italic.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-MediumItalic.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/IBM/type/tree/master/fonts/Mono/desktop/pc/IBMPlexMono-SemiBoldItalic.ttf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/sgolovine/PlexNerdfont/blob/master/Text/IBM%20Plex%20Mono%20Text%20Nerd%20Font%20Complete%20Mono.otf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/sgolovine/PlexNerdfont/blob/master/Regular/IBM%20Plex%20Mono%20Nerd%20Font%20Complete%20Mono.otf
wget.exe -P C:\Users\%USERNAME%\Fonts https://github.com/sgolovine/PlexNerdfont/blob/master/Medium/IBM%20Plex%20Mono%20Medium%20Nerd%20Font%20Complete%20Mono.otf
wget.exe -P C:\Users\%USERNAME%\Fonts https://www.fontsquirrel.com/fonts/download/archivo-narrow.zip
wget.exe -O Firefox_Quantum_Setup.exe -P C:\Users\%USERNAME%\Downloads "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=win64&lang=en-US"
wget.exe -O Battle_Net.exe -P C:\Users\%USERNAME%\Downloads "https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP"
wget.exe -O Razer_Synapse.exe -P C:\Users\%USERNAME%\Downloads "http://rzr.to/synapse-pc-download"
wget.exe -O DiscordSetup.exe -P C:\Users\%USERNAME%\Downloads "https://discordapp.com/api/download?platform=win"

get-appxpackage messaging | remove-appxpackage
get-appxpackage sway | remove-appxpackage
get-appxpackage commsphone | remove-appxpackage
get-appxpackage windowsphone | remove-appxpackage
get-appxpackage phone | remove-appxpackage
get-appxpackage communicationsapps | remove-appxpackage
get-appxpackage people | remove-appxpackage
get-appxpackage zunemusic | remove-appxpackage
get-appxpackage zunevideo | remove-appxpackage
get-appxpackage zune | remove-appxpackage
get-appxpackage bingfinance | remove-appxpackage
get-appxpackage bingnews | remove-appxpackage
get-appxpackage bingsports | remove-appxpackage
get-appxpackage bingweather | remove-appxpackage
get-appxpackage bing | remove-appxpackage
get-appxpackage onenote | remove-appxpackage
get-appxpackage maps | remove-appxpackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
get-appxpackage officehub | remove-appxpackage
get-appxpackage skypeapp | remove-appxpackage
get-appxpackage getstarted | remove-appxpackage
Get-AppxPackage drawboardpdf | Remove-AppxPackage
Get-AppxPackage freshpaint | Remove-AppxPackage
Get-AppxPackage nytcrossword | Remove-AppxPackage
Get-AppxPackage SurfaceHub | Remove-AppxPackage
Get-AppxPackage flipboard | Remove-AppxPackage
Get-AppxPackage -allusers *microsoft.xboxapp* | Remove-AppxPackage
get-appxpackage -allusers *3d* | remove-appxpackage
get-appxpackage -allusers *oneconnect* | remove-appxpackage
get-appxpackage -allusers *keeper* | remove-appxpackage
get-appxpackage -allusers *xing* | remove-appxpackage
get-appxpackage -allusers *sketchbook* | remove-appxpackage
get-appxpackage -allusers *empires* | remove-appxpackage
get-appxpackage -allusers *minecraft* | remove-appxpackage
get-appxpackage -allusers *bubble* | remove-appxpackage
get-appxpackage -allusers *candy* | remove-appxpackage

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
IF(!(Test-Path -Path $path))
{
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search"
}
Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0
#Restart Explorer to change it immediately
Stop-Process -name explorer

RefreshEnvPath

Write-Output "Finished! Run `choco upgrade all` to get the latest software"
