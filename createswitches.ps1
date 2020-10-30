#create switches
Import-Module Hyper-V

$ethernet = Get-NetAdapter -Name ethernet

$wifi = Get-NetAdapter -Name wi-fi

#comment useless line 

New-VMSwitch -Name EthEset -NetAdapterName $ethernet.Name -AllowManagementOS $true -Notes ‘Parent OS, VMs, LAN’
#New-VMSwitch -Name WiFiEset -NetAdapterName $wifi.Name -AllowManagementOS $true -Notes ‘Parent OS, VMs, wifi’

Write-Host "switches has been created"
