Find-Module "AWS.Tools.Cloud*"
Get-Module -ListAvailable

Install-Module -Name "AWS.Tools.CloudWatch" -Scope AllUsers
Install-Module -Name "AWS.Tools.CloudWatchLogs" -Scope AllUsers
Get-Command -Module AWS.Tools.CloudWatch
Get-Command -Module "AWS.Tools.CloudWatchLogs"


Import-Module "AWS.Tools.CloudWatchLogs"
$LogGroup = "/dba/LogGroup"
$LogStream = "TestLog"
New-CWLLogGroup -LogGroupName $LogGroup
New-CWLLogStream -LogGroupName $LogGroup -LogStreamName $LogStream 
Write-CWLLogEvent -LogGroupName $LogGroup -LogStreamName $LogStream -LogEvent $LogEvent 
Get-Help Write-CWLLogEvent
(Get-Command -Name Write-CWLLogEvent).Parameters.LogEvent
$LogEvent = [Amazon.CloudWatchLogs.Model.InputLogEvent]::new()
$LogEvent.Message = 'Test Message'
$LogEvent.Timestamp = Get-Date

git config --global user.email "conrad.gauntlett@awaze.com"
  git config --global user.name "Conrad Gauntlett"