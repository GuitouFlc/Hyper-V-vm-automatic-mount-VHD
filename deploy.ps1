#Use as Administrator. Tools for create and deploy ERA VM in Hyper-V
# usage example : ./deploy.ps1 config.psd1

#Define the server name
function CreateSwitches () {
#create switches (comment line 8 to 10 if not needed)
#parameters can be modify in createswitches.ps1

#Powershell.exe -executionpolicy remotesigned -File  "C:\VMs\ESET\createswitches.ps1"
#Write-Host "Waiting for Virtual switches loading"
#Start-Sleep 30
}

function ConfVm () {
$configfile = $args[0]

    #Create a new folder
    $VMFolderPath= $config.BaseFolderPath + $config.VMNAME + "\"
    
    try{
       New-Item $VMFolderPath -ItemType directory -ErrorAction STOP
    }
    catch {
    Write-Host $_   
    }
}

function CreateVm () {
$configfile = $args[0]

    #List and chose switch
    Write-Host "--------AVAILABLE SWITCHES--------" -BackgroundColor Black
    Get-VMSwitch | Select-Object -ExpandProperty Name
    Write-Host "--------Selected Switch--------" -BackgroundColor Black
    $vmSwitch = Read-Host "Please enter a virtual switch name"

    #Create a new VM, and attach the VHD
    New-VM -Name $config.VMName -MemoryStartupBytes $config.StartingMemory -VHDPath $config.VHD
    Start-Sleep 5

    #Add Network
    ADD-VMNetworkAdapter –VMName $config.VMName –Switchname $vmSwitch
}

function StartVm () {
$configfile = $args[0]

#Start the VM
    Start-VM -Name $config.VMName
    Write-Host $config.VMName" is now started"
}

function main () {
    ## Config import
    $configfile = $args[0]

    if (Test-Path -Path $configfile) {
    } 
    else {
        Write-Host ("File " + $configfile + " does not exists")
        exit 1
    }
    try {
        $config = Import-PowerShellDataFile -Path $configfile
    }
    catch {
        Write-Host $_.Exception
    }

    CreateSwitches 
    ConfVm $config
    CreateVm $config
    StartVm $config
}

if ($args.Length -gt 0) {
    main $args[0]
} else {
    Write-Host ("Arguments not fully specified")
    Write-Host ("Specify config file as argument like: DomainDeploymentTool.ps1 <config file name>")
    exit 1
}
