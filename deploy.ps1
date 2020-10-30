#Use as Administrator. Tools for create and deploy ERA VM in Hyper-V

#####Define the server name
$VMName="VM_ESET_V7"

#####create switches (comment if not needed)
#####parameters can be modify in createswitches.ps1
#Powershell.exe -executionpolicy remotesigned -File  "C:\VMs\ESET\createswitches.ps1"

#Write-Host "Waiting for Virtual switches loading"
#Start-Sleep 30

#####List and chose switch
Write-Host "--------AVAILABLE SWITCHES--------" -BackgroundColor Black
Get-VMSwitch | Select-Object -ExpandProperty Name
Write-Host "--------Selected Switch--------" -BackgroundColor Black
$vmSwitch = Read-Host "Please enter a virtual switch name"

#####Starting Memory
$StartingMemory=4GB

#####Set the base folder, on production servers, this will be something like D:\VMS\
$BaseFolderPath="C:\VMs\"

#####Set variables
$VMFolderPath=$BaseFolderPath + $VMNAME + "\"

$VHD = "C:\VMs\ESET\ESMC_Appliance.vhd"

#####Create a new folder
try{

   New-Item $VMFolderPath -ItemType directory -ErrorAction STOP
}
catch {
Write-Host $_   
}

#####Create a new VM, and attach the VHD
New-VM -Name $VMName -MemoryStartupBytes $StartingMemory -VHDPath $VHD
Start-Sleep 5

#####Add Network
ADD-VMNetworkAdapter –VMName $VMName –Switchname $vmSwitch

#####Set dynamic memory
#Set-VMMemory $VMName -DynamicMemoryEnabled $true
#Start-Sleep 8

#####Start the VM
Start-VM -Name $VMName

Write-Host $VMName" is now started"
