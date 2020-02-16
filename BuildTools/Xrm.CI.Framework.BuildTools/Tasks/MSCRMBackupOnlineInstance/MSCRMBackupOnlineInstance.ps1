[CmdletBinding()]

param()

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering MSCRMBackupOnlineInstance.ps1'

#Get Parameters
$apiUrl = Get-VstsInput -Name apiUrl -Require
$username = Get-VstsInput -Name username -Require
$password = Get-VstsInput -Name password -Require
$instanceName = Get-VstsInput -Name instanceName -Require
$backupLabel = Get-VstsInput -Name backupLabel -Require
$notes = Get-VstsInput -Name notes
$waitForCompletion = Get-VstsInput -Name waitForCompletion -AsBool
$sleepDuration = Get-VstsInput -Name sleepDuration -AsInt
$backupExistsAction = Get-VstsInput -Name backupExistsAction -Require

#MSCRM Tools
$mscrmToolsPath = $env:MSCRM_Tools_Path
Write-Verbose "MSCRM Tools Path: $mscrmToolsPath"

if (-not $mscrmToolsPath)
{
	Write-Error "MSCRM_Tools_Path not found. Add 'MSCRM Tool Installer' before this task."
}

$PSModulePath = "$mscrmToolsPath\OnlineManagementAPI\1.1.0"

& "$mscrmToolsPath\xRMCIFramework\9.0.0\BackupOnlineInstance.ps1" -ApiUrl $apiUrl -Username $username -Password $password -InstanceName $instanceName -BackupLabel "$backupLabel" -BackupNotes "$notes" -WaitForCompletion $waitForCompletion -SleepDuration $sleepDuration -PSModulePath $PSModulePath -BackupExistsAction $backupExistsAction

Write-Verbose 'Leaving MSCRMBackupOnlineInstance.ps1'
