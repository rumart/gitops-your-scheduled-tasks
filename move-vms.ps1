$vcenter = $ENV:VCENTER_SERVER
$username = $ENV:VCENTER_USER
$password = $ENV:VCENTER_PASSWORD

try {
    Write-Output "Connecting to vCenter $vCenter"

    Connect-VIServer -Server $vcenter -User $username -Password $password -ErrorAction Stop
}
catch {
    Write-Error "Couldn't connect to vCenter $vCenter"
    break
}

$stagingFolder = Get-Folder -Type VM -Name Staging
$customerRoot = Get-Folder -Type VM -Name Customers

$vms = $stagingFolder | Get-VM
Write-Output "Found $($vms.count) vms to process"
foreach($vm in $vms){
    $vmName = $vm.Name
    Write-Output "Processing vm $vmName"

    $custName = $vmName.Substring(0,1)

    Write-Output "Searching for customer folder"
    $custFolder = Get-Folder -Type VM -Name "Cust-$custName" -Location $customerRoot

    try{
        Write-Output "Moving VM $vmName to customer folder"
        $vm | Move-VM -InventoryLocation $custFolder | Out-Null
    }
    catch{
        Write-Error "Couldn't move vm $vmName to correct folder"
        continue
    }
    
}
Write-Output "Disconnecting from vCenter $vCenter"
Disconnect-VIServer $vcenter -Confirm:$false
