#
# de-danielmeixner-anycode-runaci.ps1
#
[CmdletBinding(DefaultParameterSetName = 'None')]
param(
	
    [string][Parameter(Mandatory = $false)] $resourcegroupnameA, 
    [string][Parameter(Mandatory = $false)] $containernameA
)

Write-Host "Starting de-danielmeixner-anycode-runaci"

# Save-Module -Name VstsTaskSdk -Path .\ 
# see https://github.com/Microsoft/vsts-task-lib/tree/master/powershell/Docs
#Trace-VstsEnteringInvocation $MyInvocation

try {
    Import-VstsLocStrings "$PSScriptRoot\task.json"


    Write-Host "resourcegroupname: "$resourcegroupnameA
    Write-Host "containername: "$containernameA
}
catch {

}
finally {
    #Trace-VstsLeavingInvocation $MyInvocation
}

Write-Host "Gettting Get-VstsInput ..."  
$resourcegroupname =  Get-VstsInput -Name resourcegroupname
$containername =  Get-VstsInput -Name containername
$image =  Get-VstsInput -Name image
$user =  Get-VstsInput -Name user
$password =  Get-VstsInput -Name password
$tenant =  Get-VstsInput -Name tenant
$environmentvariables = Get-VstsInput -Name environmentvariables 

Write-Host "Logging in..."
az login --service-principal -u $user  -p $password --tenant $tenant

Write-Host "resourcegroupname: " $resourcegroupname
Write-Host "containername: " $containername

# create
Write-Host "Creating RG..."
az group create --name $resourcegroupname --location eastus
Write-Host "Create Con"
az container create --resource-group $resourcegroupname --name $containername --image $image --restart-policy OnFailure --environment-variables $environmentvariables

Write-Host "Check for start..."
Write-Host "resourcegroupname: " $resourcegroupname
Write-Host "containername: " $containername
# wait for container to start


$i = 0
while (!($res= az container show --resource-group $resourcegroupname  --name $containername --query provisioningState)) {
    Write-Host "waiting for container to start ...("$i")"
    $i++
    Start-Sleep 1
}

Write-Host "Check for prov..."
$j = 0
while (!($cst =  az container show --resource-group $resourcegroupname  --name $containername --query provisioningState).contains("Succeeded")) {
    Write-Host "waiting for container to provision ...("$j")"
    $j++
    Start-Sleep 1
}

Write-Host "Check for termination..."
Write-Host "resourcegroupname: " $resourcegroupname
Write-Host "containername: " $containername
# wait for container to finish job or die
# todo: handle cases when container is in another state for too long
# todo: kill container after customtimeout
$ic = 0
while (!($stt = az container show --resource-group $resourcegroupname  --name $containername --query containers[0].instanceView.currentState.state).contains("Terminated")) {
    Write-Host "Current container state is" $stt"("$ic")"
    $ic++
    Start-Sleep 1
}

# print logs
az container logs --resource-group $resourcegroupname --name $containername

Write-Host "Ending de-danielmeixner-anycode-runaci"