[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMDeleteOnlineInstance.ps1'

$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$tenantId = Get-VstsInput -Name tenantId
$sourceInstanceName = Get-VstsInput -Name sourceInstanceName -Require
$targetInstanceName = Get-VstsInput -Name targetInstanceName -Require
$copyType = Get-VstsInput -Name copyType -Require
$friendlyName = Get-VstsInput -Name friendlyName
$securityGroupName = Get-VstsInput -Name securityGroupName
$waitForCompletion = Get-VstsInput -Name waitForCompletion -AsBool
$sleepDuration = Get-VstsInput -Name sleepDuration -AsInt

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'Power DevOps Tool Installer' before this task."
}

."$mscrmToolsPath\MSCRMToolsFunctions.ps1"

Require-ToolsTaskVersion -version 12

$onlineAPI = 'Microsoft.Xrm.OnlineManagementAPI'
$onlineAPIInfo = Get-MSCRMTool -toolName $onlineAPI
Require-ToolVersion -toolName $onlineAPI -version $onlineAPIInfo.Version -minVersion '1.2.0.1'
$onlineAPIPath = "$($onlineAPIInfo.Path)"

$azureAD = 'AzureAD'
$azureADInfo = Get-MSCRMTool -toolName $azureAD
Require-ToolVersion -toolName $azureAD -version $azureADInfo.Version -minVersion '2.0.2.52'
$azureADPath = "$($azureADInfo.Path)"

$copyParams = @{
	ApiUrl = $apiUrl
	Username = $username
	Password = $password
	sourceInstanceName = $sourceInstanceName
	targetInstanceName = $targetInstanceName
	copyType = $copyType
	friendlyName = "$friendlyName"
	securityGroupName = "$securityGroupName"
	PSModulePath = $onlineAPIPath
	azureADModulePath = "$azureADPath"
	WaitForCompletion = $WaitForCompletion
	SleepDuration = $sleepDuration
}

if ($tenantId)
{
	$copyParams.TenantId = "$tenantId"
}

& "$mscrmToolsPath\xRMCIFramework\9.0.0\CopyOnlineInstance.ps1" @copyParams

Write-Verbose 'Leaving MSCRMRestoreOnlineInstance.ps1'
