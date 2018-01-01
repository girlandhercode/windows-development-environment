# Include the Pin/Unpin library from some random blog post online
function Pin-App ([string]$appname, [switch]$unpin, [switch]$start, [switch]$taskbar, [string]$path) {
    if ($unpin.IsPresent) {
        $action = "Unpin"
    } else {
        $action = "Pin"
    }

    if (-not $taskbar.IsPresent -and -not $start.IsPresent) {
        Write-Error "Specify -taskbar and/or -start!"
    }

    if ($taskbar.IsPresent) {
        try {
            $exec = $false
            if ($action -eq "Unpin") {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
                if ($exec) {
                    Write "App '$appname' unpinned from Taskbar"
                    #timeout /t 1 # You have to delay slightly if there are a lot of operations, otherwise Windows wont keep up.
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action
                    } else {
                        Write "'$appname' not found or 'Unpin from taskbar' not found on item!"
                    }
                }
            } else {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Pin to taskbar'} | %{$_.DoIt(); $exec = $true}

                if ($exec) {
                    Write "App '$appname' pinned to Taskbar"
                    #timeout /t 1 # You have to delay slightly if there are a lot of operations, otherwise Windows wont keep up.
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action
                    } else {
                        Write "'$appname' not found or 'Pin to taskbar' not found on item!"
                    }
                }
            }
        } catch {
            Write-Error "Error Pinning/Unpinning $appname to/from taskbar!"
        }
    }

    if ($start.IsPresent) {
        try {
            $exec = $false
            if ($action -eq "Unpin") {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start'} | %{$_.DoIt(); $exec = $true}

                if ($exec) {
                    Write "App '$appname' unpinned from Start"
                    #timeout /t 1 # You have to delay slightly if there are a lot of operations, otherwise Windows wont keep up.
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action -start
                    } else {
                        Write "'$appname' not found or 'Unpin from Start' not found on item!"
                    }
                }
            } else {
                ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Pin to Start'} | %{$_.DoIt(); $exec = $true}

                if ($exec) {
                    Write "App '$appname' pinned to Start"
			        #timeout /t 1 # You have to delay slightly if there are a lot of operations, otherwise Windows wont keep up.
                } else {
                    if (-not $path -eq "") {
                        Pin-App-by-Path $path -Action $action -start
                    } else {
                        Write "'$appname' not found or 'Pin to Start' not found on item!"
                    }
                }
            }
        } catch {
            Write-Error "Error Pinning/Unpinning $appname to/from Start!"
        }
    }
}

function Pin-App-by-Path([string]$Path, [string]$Action, [switch]$start) {
    if ($Path -eq "") {
        Write-Error -Message "You need to specify a Path" -ErrorAction Stop
    }
    if ($Action -eq "") {
        Write-Error -Message "You need to specify an action: Pin or Unpin" -ErrorAction Stop
    }
    if ((Get-Item -Path $Path -ErrorAction SilentlyContinue) -eq $null){
        Write-Error -Message "$Path not found" -ErrorAction Stop
    }
    $Shell = New-Object -ComObject "Shell.Application"
    $ItemParent = Split-Path -Path $Path -Parent
    $ItemLeaf = Split-Path -Path $Path -Leaf
    $Folder = $Shell.NameSpace($ItemParent)
    $ItemObject = $Folder.ParseName($ItemLeaf)
    $Verbs = $ItemObject.Verbs()

    if ($start.IsPresent) {
        switch($Action){
            "Pin"   {$Verb = $Verbs | Where-Object -Property Name -EQ "&Pin to Start"}
            "Unpin" {$Verb = $Verbs | Where-Object -Property Name -EQ "Un&pin from Start"}
            default {Write-Error -Message "Invalid action, should be Pin or Unpin" -ErrorAction Stop}
        }
    } else {
        switch($Action){
            "Pin"   {$Verb = $Verbs | Where-Object -Property Name -EQ "Pin to Tas&kbar"}
            "Unpin" {$Verb = $Verbs | Where-Object -Property Name -EQ "Unpin from Tas&kbar"}
            default {Write-Error -Message "Invalid action, should be Pin or Unpin" -ErrorAction Stop}
        }
    }

    if($Verb -eq $null){
        Write-Error -Message "That action is not currently available on this Path" -ErrorAction Stop
    } else {
        $Result = $Verb.DoIt()
    }
}



# Unpin the annoying stuff from Windows taskbar
Pin-App "Microsoft Edge" -unpin -taskbar
Pin-App "SourceTree" -unpin -taskbar
Pin-App "Store" -unpin -taskbar

# Unpin the annoying stuff from Windows start
Pin-App "Mail" -unpin -start
Pin-App "Store" -unpin -start
Pin-App "Calendar" -unpin -start
Pin-App "Microsoft Edge" -unpin -start
Pin-App "Photos" -unpin -start
Pin-App "Cortana" -unpin -start
Pin-App "Weather" -unpin -start
Pin-App "Phone Companion" -unpin -start
Pin-App "Twitter" -unpin -start
Pin-App "Skype Video" -unpin -start
Pin-App "Candy Crush Soda Saga" -unpin -start
Pin-App "xbox" -unpin -start
Pin-App "Groove music" -unpin -start
Pin-App "movies & tv" -unpin -start
Pin-App "microsoft solitaire collection" -unpin -start
Pin-App "Minecraft: Windows 10 Edition Beta" -unpin -start
Pin-App "Flipboard" -unpin -start
Pin-App "PicsArt - Photo Studio" -unpin -start
Pin-App "money" -unpin -start
Pin-App "get office" -unpin -start
Pin-App "onenote" -unpin -start
Pin-App "news" -unpin -start
Pin-App "Age of Empires: Castle Siege" -unpin -start
Pin-App "Minecraft: Windows 10 edition" -unpin -start
Pin-App "FarmVille2: Country Escape" -unpin -start
Pin-App "World of Tanks: Blitz" -unpin -start
Pin-App "Asphalt 8: Airborne" -unpin -start
Pin-App "Get office" -unpin -start

# Unpin our set of desired applications from start
# there is a separate script to re-pin if desired
# Pin-App "This PC" -unpin -start
# Pin-App "Windows PowerShell" -unpin -start
Pin-App "Cortana" -unpin -start
# Pin-App "Google Chrome" -unpin -start
# Pin-App "Mozilla Firefox" -unpin -start
# Pin-App "Internet Explorer" -unpin -start
# Pin-App "Microsoft Edge" -unpin -start
# Pin-App "Outlook 2016" -unpin -start
Pin-App "Skype for Business 2016" -unpin -start
Pin-App "Skype" -unpin -start
# Pin-App "Word 2016" -unpin -start
# Pin-App "Excel 2016" -unpin -start
# Pin-App "PowerPoint 2016" -unpin -start
Pin-App "Visual Studio 2015" -unpin -start
# Pin-App "Visual Studio Code" -unpin -start
# Pin-App "Fiddler4" -unpin -start
# Pin-App "SourceTree" -unpin -start
# Pin-App "Sublime Text 3" -unpin -start
# Pin-App "Notepad++" -unpin -start
