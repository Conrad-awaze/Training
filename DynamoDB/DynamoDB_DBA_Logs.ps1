
# Find-Module -Name "AWS.Tools.Dy*"
Install-Module -Name 'AWS.Tools.DynamoDBv2' -Force

Set-AWSCredential -StoreAs Conrad -AccessKey <> -SecretKey <>
Initialize-AWSDefaultConfiguration -ProfileName Conrad -Region eu-west-2

$TableName = "DBA_LOGS-$($env:COMPUTERNAME)-TEST"

# $exampleSchema = New-DDBTableSchema | Add-DDBKeySchema -KeyName "PK" -KeyDataType "S"
# $exampleTable = New-DDBTable $TableName -Schema $exampleSchema -ReadCapacity 5 -WriteCapacity 5

#create database connection
Add-Type -Path (${env:ProgramFiles(x86)}+"\AWS SDK for .NET\bin\Net45\AWSSDK.DynamoDBv2.dll")

$regionName = 'eu-west-2'
$regionEndpoint=[Amazon.RegionEndPoint]::GetBySystemName($regionName)
$dbClient = New-Object Amazon.DynamoDBv2.AmazonDynamoDBClient($regionEndpoint)

function putDDBItem{
    param (

          [string]$TableName,
          [string]$PK,
          [string]$vPK,
          [string]$SK,
          [string]$vSK,
          [string]$key3,
          [string]$val3

    )

    $req = New-Object Amazon.DynamoDBv2.Model.PutItemRequest

    $req.TableName = $tableName
    $req.Item = New-Object 'system.collections.generic.dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'

    #------------------------------------------------------------------------------
    # Partition Key

    $valObj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
    $valObj.S = $vPK
    $req.Item.Add($PK, $valObj)

    #------------------------------------------------------------------------------
    # Sort Key

    $val1Obj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
    $val1Obj.S = $vSK
    $req.Item.Add($SK, $val1Obj)

    #------------------------------------------------------------------------------
    # Attribute 3

    $val3Obj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
    $val3Obj.S = $val3
    $req.Item.Add($key3, $val3Obj)

    #------------------------------------------------------------------------------
    $output = $dbClient.PutItemAsync($req)
    $output
    
}

$putParams = @{

    tableName = $TableName 
    PK      = 'LogFile' 
    vPK     = "Database Refresh - DEV -  FusionWebToolkitPubAppServ  20220811_0952AM" 
    SK      = 'EventTime' 
    # vSK     = "RefreshLog-$(get-date -format "dd/MM/yyyy-hh:mm:ss:tt")"
    vSK     = $(get-date -format "dd/MM/yyyy hh:mm:ss:ms:tt")
    key3    = "Message"
    val3    = "DBO Access - [OneConnectDev] - account added"

}
putDDBItem @putParams

# $putParams = @{

#     tableName = $TableName 
#     PK      = 'PK' 
#     vPK     = "$(get-date -format "dd/MM/yyyy")-$($env:COMPUTERNAME)" 
#     SK      = 'SK' 
#     vSK     = "DatabaseRefresh-FusionWebToolkitPubAppServ-$(get-date -format "dd/MM/yyyy-hh:mm:ss:tt")"
#     #vSK     = "DatabaseRefresh-FusionWebToolkitPubAppServ-02/09/2022-02:26:36:PM"
#     key3    = "EventTime"
#     val3    = "11/08/2022 10:11:10"
#     key4    = "Message"
#     val4    = "DBO Access - [VRUKL\SDLCDev] - account added2"

# }
# putDDBItem @putParams


$key = 'PK' 
$keyAttrStr = '02/09/2022-HV-WIN10-LAB'

function getDDBItem{
      param (
              [string]$tableName,
              [string]$key,
              [string]$keyAttrStr
              )
  $req = New-Object Amazon.DynamoDBv2.Model.GetItemRequest
  $req.TableName = $tableName
  $req.Key = New-Object 'system.collections.generic.dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'
  $keyAttrObj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
  $keyAttrObj.S = $keyAttrStr
  $req.Key.Add($key, $keyAttrObj.S)
  $script:resp = $dbClient.GetItemAsync($req)
}

getDDBItem -tableName $TableName -key 'PK' -keyAttrStr '02/09/2022-HV-WIN10-LAB'


getDDBItem -tableName $tableName -key 'Name' -keyAttrStr 'Sid'

Write-Host "$($script:resp.Result.Item.'Name'.S) is $($script:resp.Result.Item.'Age'.S)"
$script:resp = $null

putDDBItem 
putDDBItem -tableName $TableName -PK 'PK' -val 'Bob' -key1 'Age' -val1 '22' -key2 'LastName' -val2 'Dodd'
putDDBItem -tableName $TableName -key 'Name' -val 'Bert' -key1 'Age' -val1 '23' -key2 'LastName' -val2 'Sesame'
putDDBItem -tableName $TableName -key 'Name' -val 'Bert2' -key1 'Age' -val1 '24' -key2 'LastName' -val2 'Sesame2'
# putDDBItem -tableName $TableName -key 'Name' -val 'Sid' -key1 'Age' -val1 '23'
putDDBItem -tableName 'LOGS-HV-Win10-Lab' -key 'Name' -val 'Sid' -key1 'Age' -val1 '23'






$req = New-Object Amazon.DynamoDBv2.Model.PutItemRequest

$req |Get-Member

$req = New-Object Amazon.DynamoDBv2.Model.PutItemRequest
$req.TableName = $tableName
$req.Item = New-Object 'system.collections.generic.dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'
$valObj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
$valObj.S = $val
$req.Item.Add($key, $valObj)
$val1Obj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
$val1Obj.S = $val1
$req.Item.Add($key1, $val1Obj)
$val2Obj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
$val2Obj.S = $val2
$req.Item.Add($key2, $val2Obj)
$output = $dbClient.PutItemAsync($req)
